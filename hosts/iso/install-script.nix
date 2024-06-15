pkgs:
pkgs.writeShellScriptBin "install-os" ''
  set -euo pipefail

  bold=$'\033[1m'
  red=$'\033[1;31m'
  normal=$'\033[0m'

  echo "Your NixOS configuration must be listed in $bold~/dots/flake.nix$normal for this script to work. Don't forget to import ''${bold}nixosModules/disko.nix$normal with the correct disk name!"

  while true; do
    read -rn 1 -p 'Do you want to continue? ' result
    case $result in
      [Yy] ) break;;
      [Nn] ) exit;;
      * ) echo;;
    esac
  done

  disk=$(lsblk -dno name | fzf --border --border-label 'Disk selection' --prompt 'Disk> ' --preview 'lsblk /dev/{}')

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

  sudo disko -m disko ~/dots/nixosModules/disko.nix --arg device "\"/dev/$disk\""

  echo -e "\nSuccessfully formatted the disk $bold$disk$normal!"

  config=$(nix eval ~/dots#nixosConfigurations --no-warn-dirty --raw --apply 'a: builtins.concatStringsSep "\n" (builtins.attrNames a)' | fzf --border --border-label 'Configuration selection' --prompt 'Config> ')

  echo -e "\nInstalling NixOS using the $bold$config$normal configuration..."

  sudo nixos-install --flake ~/dots#"$config"

  echo $'\nCopying the configuration...'
  sudo cp -r ~/dots /mnt/etc/nixos

  echo 'Copying WIFI connections...'
  sudo cp -r /etc/NetworkManager/system-connections /mnt/etc/NetworkManager/system-connections

  echo "NixOS has been successfully installed on $bold$disk$normal using the $bold$config$normal configuration!"
''
