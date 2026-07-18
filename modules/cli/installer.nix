{lib, ...}: {
  perSystem = {pkgs, ...}: {
    packages = rec {
      build-installer = pkgs.writers.writeNuBin "build-installer" "${lib.getExe pkgs.nix-output-monitor} build /etc/nixos#nixosConfigurations.installer.config.system.build.isoImage";

      test-installer = pkgs.writers.writeNuBin "test-installer" ''
        if not ('/etc/nixos/result/iso' | path exists) { ${lib.getExe build-installer} }
        ${lib.getExe' pkgs.qemu "qemu-system-x86_64"} -enable-kvm -m 4G -cdrom /etc/nixos/result/iso/nixos-*.iso
      '';

      write-installer = pkgs.writers.writeNuBin "write-installer" ''
        if not ('/etc/nixos/result/iso' | path exists) { ${lib.getExe build-installer} }

        let disk = lsblk --nodeps --noheadings --output name,size | ${lib.getExe pkgs.fzf} --accept-nth 1 --preview 'lsblk /dev/{1}'

        print $'Overwriting a disk can result in the (ansi red_bold)permanent loss(ansi reset) of its contents!'
        loop {
          match (input --numchar 1 $'Would you like to overwrite the disk (ansi attr_bold)($disk)(ansi reset)? ') {
            Y | y => break
            N | n => return
          }
        }

        print 'Unmounting the disk...'
        try { sudo umount /dev/($disk)* }

        print 'Writing...'
        sudo dd bs=4M conv=fsync oflag=direct status=progress if=(glob /etc/nixos/result/iso/nixos-*.iso | first) of=/dev/($disk)

        print $'The installer ISO was successfully written to (ansi attr_bold)($disk)(ansi reset)!'
      '';
    };
  };
}
