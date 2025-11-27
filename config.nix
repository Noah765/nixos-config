{
  defaultHmUsername = "noah";

  globalModules = [./modules];

  configurations = {
    primary.modules = [hosts/primary];
    laptop.modules = [./hosts/laptop];
    iso.modules = [./hosts/iso];
  };

  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs.lib) genAttrs getExe' mapAttrs systems;
    forAllSystems = f: mapAttrs f (genAttrs systems.flakeExposed (x: nixpkgs.legacyPackages.${x}));
  in {
    devShells = forAllSystems (_: pkgs: {
      default = pkgs.mkShell {packages = [pkgs.alejandra pkgs.kdePackages.qtdeclarative];};

      # TODO
      test-installer = pkgs.mkShell {
        buildInputs = [
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
    });

    formatter = forAllSystems (_: pkgs: pkgs.alejandra);
  };
}
