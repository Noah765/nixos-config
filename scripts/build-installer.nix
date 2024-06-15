pkgs:
pkgs.writeShellScriptBin "build-installer" ''
  set -euo pipefail

  bold=$'\033[1m'
  normal=$'\033[0m'

  echo "Your installer NixOS configuration must be located at $bold/etc/nixos#iso$normal for this script to work"

  while true; do
    read -rn 1 -p 'Do you want to continue? ' result
    case $result in
      [Yy] ) break;;
      [Nn] ) exit;;
      * ) echo;;
    esac
  done

  sudo nix build /etc/nixos#nixosConfigurations.iso.config.system.build.isoImage

  echo "The installer ISO has been successfully created and is located in $bold/etc/nixos/result/iso$normal!"
''


