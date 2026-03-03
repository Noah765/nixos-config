{
  initialInputs.treefmt.url = "github:numtide/treefmt-nix";
  initialInputs.treefmt.inputs.nixpkgs.follows = "nixpkgs";
  initialInputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

  defaultHmUsername = "noah";

  globalModules = [./modules];

  configurations = {
    primary.modules = [hosts/primary];
    laptop.modules = [./hosts/laptop];
    iso.modules = [./hosts/iso];
  };

  outputs = {
    nixpkgs,
    treefmt,
    ...
  }: let
    eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (x: f nixpkgs.legacyPackages.${x});

    formatter = pkgs:
      (treefmt.lib.evalModule pkgs {
        programs = {
          alejandra.enable = true;
          deadnix.enable = true;
          qmlformat.enable = true;
          statix.enable = true;
        };

        settings.formatter.qmlformat.options = ["--indent-width=2" "--sort-imports" "--semicolon-rule=essential"];
      }).config.build.wrapper;
  in {
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {packages = [pkgs.quickshell (formatter pkgs)];};

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
            ${nixpkgs.lib.getExe' pkgs.qemu "qemu-img"} create /tmp/installer.img 20G
            trap 'rm -f /tmp/installer.img' EXIT
            ${nixpkgs.lib.getExe' pkgs.qemu "qemu-system-x86_64"} -enable-kvm -m 4G -bios ${pkgs.OVMF.fd}/FV/OVMF.fd -cdrom /etc/nixos/result/iso/nixos-*.iso -drive file=/tmp/installer.img,format=raw
          '')
        ];
        shellHook = "test-installer";
      };
    });

    formatter = eachSystem formatter;
  };
}
