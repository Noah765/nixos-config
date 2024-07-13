pkgs:
pkgs.writeShellScriptBin "download" ''
  set -euo pipefail

  git clone https://github.com/Noah765/dots ~/dots

  bold=$'\033[1m'
  normal=$'\033[0m'
  echo -e "\nSuccessfully downloaded the dots into $bold~/dots$normal!"
''
