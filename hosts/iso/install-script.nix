pkgs:
pkgs.writeShellScriptBin "install-os" ''
  set -euo pipefail

  bold=$'\033[1m'
  red=$'\033[1;31m'
  normal=$'\033[0m'

  echo "Your NixOS configuration must be listed in $bold~/config/flake.nix$normal for this script to work. Don't forget to set the ''${bold}core.impermanence.disk$normal option to the correct disk name if you want to use impermanence!"
  while true; do
    read -rn 1 -p 'Do you want to continue? ' result
    case $result in
      [Yy] ) break;;
      [Nn] ) exit;;
      * ) echo;;
    esac
  done

  config=$(nix eval ~/config#combinedManagerConfigurations --no-warn-dirty --raw --apply 'a: builtins.concatStringsSep "\n" (builtins.attrNames a)' | fzf --border --border-label 'Configuration selection' --prompt 'Config> ')
  impermanence=$(nix eval ~/config#combinedManagerConfigurations."$config".config.core.impermanence.enable --no-warn-dirty)

  if $impermanence; then
    disk=$(nix eval ~/config#combinedManagerConfigurations."$config".config.core.impermanence.disk --no-warn-dirty --raw)

    echo -e "\nFormatting a disk can cause the disk's contents to be ''${red}lost forever$normal!"
    while true; do
      read -rn 1 -p "Do you wish to format the disk $bold$disk$normal? " result
      case $result in
        [Yy] ) break;;
        [Nn] ) exit;;
        * ) echo;;
      esac
    done

    echo $'\nFormatting...'
    sudo disko -m disko -f ~/config#"$config"
    echo -e "\nSuccessfully formatted the disk $bold$disk$normal!"
  fi

  echo -e "\nInstalling NixOS using the $bold$config$normal configuration...\n"
  sudo nixos-install --flake ~/config#"$config"

  echo $'\nCopying the configuration...'
  sudo cp -r ~/config/. /mnt/persist/system/etc/nixos

  echo $'\nCopying WIFI connections...'
  sudo cp -r /etc/NetworkManager/system-connections /mnt/persist/system/etc/NetworkManager

  echo -e "\nNixOS has been successfully installed on $bold$disk$normal using the $bold$config$normal configuration!"
''
