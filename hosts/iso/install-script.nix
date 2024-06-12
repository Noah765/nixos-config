pkgs:
pkgs.writeShellScriptBin "install" ''
  set -euo pipefail

  bold=$'\033[1m'
  red=$'\033[1;31m'
  normal=$'\033[0m'

  echo "Your NixOS configuration must be listed in $bold~/dots/flake.nix$normal for this script to work"

  while true; do
    read -rn 1 -p $'\nDo you want to continue? ' result
    case $result in
      [Yy] ) break;;
      [Nn] ) exit;;
    esac
  done

  disk=$(lsblk -dno name | fzf --border --border-label 'Disk selection' --prompt 'Disk> ' --preview 'lsblk /dev/{}')

  echo "Formatting a disk can cause the disk's contents to be $\{red}lost forever$normal!"
  while true; do
    read -rn 1 -p $'\n'"Do you wish to format the disk $bold$disk$normal? " result
    case $result in
      [Yy] ) break;;
      [Nn] ) exit;;
    esac
  done

  echo $'\nFormatting...'

  sudo disko -m disko ~/dots/nixosModules/disko.nix --arg device "\"$disk\""

  echo $'\n'"Successfully formatted the disk $bold$disk$normal!"

  config=$(nix eval ~/dots#nixosConfigurations --no-warn-dirty --raw --apply 'a: builtins.concatStringsSep "\n" (builtins.attrNames a)' | fzf --border --border-label 'Configuration selection' --prompt 'Config> ')

  echo "Installing NixOS using the $bold$config$normal configuration..."

  sudo nixos-install --flake "~/dots#$config"

  echo 'Copying the configuration...'
  sudo cp -r ~/dots /mnt/etc/nixos

  echo "NixOS was successfully installed on $bold$disk$normal using the $boldconfig$normal configuration!"
''
