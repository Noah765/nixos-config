pkgs:
pkgs.writeShellScriptBin "write-installer" ''
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

  image=$(ls /etc/nixos/result/iso | head -n1)
  disk=$(lsblk -dno name | fzf --border --border-label 'Disk selection' --prompt 'Disk> ' --preview 'lsblk /dev/{}')

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
  sudo dd bs=4M conv=fsync oflag=direct status=progress if="/etc/nixos/result/iso/$image" of="/dev/$disk"

  echo -e "\nThe installer ISO has been successfully written to $bold$disk$normal!"
''
