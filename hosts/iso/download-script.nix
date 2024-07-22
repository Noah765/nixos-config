pkgs:
pkgs.writeShellScriptBin "download" ''
  set -euo pipefail

  git clone https://github.com/Noah765/nixos-config ~/config

  bold=$'\033[1m'
  normal=$'\033[0m'
  echo -e "\nSuccessfully downloaded the config into $bold~/config$normal!"
''
