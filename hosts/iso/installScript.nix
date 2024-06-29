{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-os" ''
      set -euo pipefail

      bold=$'\033[1m'
      red=$'\033[1;31m'
      normal=$'\033[0m'

      echo "Your NixOS configuration must be listed in $bold~/dots/flake.nix$normal for this script to work. Don't forget to set the ''${bold}impermanence.disk$normal option to the correct disk name!"
      while true; do
        read -rn 1 -p 'Do you want to continue? ' result
        case $result in
          [Yy] ) break;;
          [Nn] ) exit;;
          * ) echo;;
        esac
      done

      config=$(nix eval ~/dots#nixosConfigurations --no-warn-dirty --raw --apply 'a: builtins.concatStringsSep "\n" (builtins.attrNames a)' | fzf --border --border-label 'Configuration selection' --prompt 'Config> ')
      disk=$(nix eval ~/dots#nixosConfigurations."$config".config.impermanence.disk --no-warn-dirty --raw)

      echo -e "\nFormatting a disk can cause the disk's contents to be ''${red}lost forever$normal!"
      while true; do
        read -rn 1 -p "Do you wish to format disk $bold$disk$normal? " result
        case $result in
          [Yy] ) break;;
          [Nn] ) exit;;
          * ) echo;;
        esac
      done

      echo $'\nFormatting...'

      sudo disko -m disko -f ~/dots#"$config"

      echo -e "\nSuccessfully formatted the disk $bold$disk$normal!"

      echo -e "\nInstalling NixOS using the $bold$config$normal configuration...\n"

      sudo nixos-install --flake ~/dots#"$config"

      echo $'\nCopying the configuration...'
      sudo cp -r ~/dots /mnt/etc/nixos

      echo $'\nCopying WIFI connections...'
      sudo cp -r /etc/NetworkManager/system-connections /mnt/etc/NetworkManager/system-connections

      echo -e "\nNixOS has been successfully installed on $bold$disk$normal using the $bold$config$normal configuration!"
    '')
  ];
}
