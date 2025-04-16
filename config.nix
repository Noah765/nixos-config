{
  defaultHmUsername = "noah";

  globalModules = [./modules];

  configurations = {
    primary.modules = [hosts/primary];
    laptop.modules = [./hosts/laptop];
    iso.modules = [./hosts/iso];
  };

  outputs = {
    self,
    nixpkgs,
    agenix-rekey,
    ...
  }: {
    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nodes = self.nixosConfigurations;
    };

    devShells.x86_64-linux.default = let
      inherit (nixpkgs.lib) getExe';
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.mkShell {
        packages = [
          # TODO
          (pkgs.writeShellScriptBin "test-installer" ''
            set -euo pipefail

            bold=$'\033[1m'
            normal=$'\033[0m'

            echo "Your installer ISO image must be located in $bold/etc/nixos/result/iso$normal for this script to work"

            while true; do
              read -rn 1 -p 'Do you want to continue? ' result
              case $result in
                [Yy] ) break;;
                [Nn] ) exit;;
                * ) echo;;
              esac
            done

            echo
            ${getExe' pkgs.qemu "qemu-img"} create /tmp/installer.img 20G
            trap 'rm -f /tmp/installer.img' EXIT
            ${getExe' pkgs.qemu "qemu-system-x86_64"} -enable-kvm -m 4G -bios ${pkgs.OVMF.fd}/FV/OVMF.fd -cdrom /etc/nixos/result/iso/nixos-*.iso -drive file=/tmp/installer.img,format=raw
          '')
        ];

        shellHook = "test-installer";
      };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
