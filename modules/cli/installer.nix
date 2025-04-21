{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) getExe mkEnableOption mkIf;
in {
  options.cli.installer.enable = mkEnableOption "scripts for building, testing and writing the installer to a USB";

  config.hm.home.packages = mkIf config.cli.installer.enable [
    (pkgs.writeShellScriptBin "build-installer" ''
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

      ${getExe pkgs.nix-output-monitor} build /etc/nixos#nixosConfigurations.iso.config.system.build.isoImage

      echo "The installer ISO has been successfully created and is located in $bold/etc/nixos/result/iso$normal!"
    '')
    (pkgs.writeShellScriptBin "write-installer" ''
      set -euo pipefail

      bold=$'\033[1m'
      red=$'\033[1;31m'
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

      disk=$(lsblk -dno name | ${getExe pkgs.fzf} --border --border-label 'Disk selection' --prompt 'Disk> ' --preview 'lsblk /dev/{}')

      echo -e "\nOverwriting a disk can cause the disk's contents to be ''${red}lost forever$normal!"
      while true; do
        read -rn 1 -p "Do you wish to overwrite the disk $bold$disk$normal? " result
        case $result in
          [Yy] ) break;;
          [Nn] ) exit;;
          * ) echo;;
        esac
      done

      echo $'\nUnmounting the disk...'
      sudo umount /dev/$disk* || true

      echo 'Writing...'
      sudo dd bs=4M conv=fsync oflag=direct status=progress if=$(echo /etc/nixos/result/iso/nixos-*.iso) of=/dev/$disk

      echo -e "\nThe installer ISO has been successfully written to $bold$disk$normal!"
    '')
  ];
}
