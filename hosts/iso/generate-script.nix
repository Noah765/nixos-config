pkgs:
pkgs.writeShellScriptBin "generate" ''
  set -euo pipefail

  bold=$'\033[1m'
  normal=$'\033[0m'

  config=$(nix eval ~/config#nixosConfigurations --no-warn-dirty --raw --apply 'a: builtins.concatStringsSep "\n" (builtins.attrNames a)' | fzf --border --border-label 'Configuration selection' --prompt 'Config> ')

  echo -e "\n$bold~/config/hosts/$config/hardware-configuration.nix$normal will be overwritten by the new hardware configuration."
  while true; do
    read -rn 1 -p 'Do you want to continue? ' result
    case $result in
      [Yy] ) break;;
      [Nn] ) exit;;
      * ) echo;;
    esac
  done

  echo $'\n'
  sudo nixos-generate-config --no-filesystems --show-hardware-config > ~/config/hosts/"$config"/hardware-configuration.nix
  alejandra ~/config/hosts/"$config"/hardware-configuration.nix

  echo -e "\nSuccessfully generated ''${bold}hardware-configuration.nix$normal at $bold~/config/hosts/$config/hardware-configuration.nix$normal!"
''
