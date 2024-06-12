pkgs:
pkgs.writeShellScriptBin "generate" ''
  set -euo pipefail

  ~/hardware-configuration.nix > sudo nixos-generate-config --no-filesystems --show-hardware-config

  bold=$'\033[1m'
  normal=$'\033[0m'
  echo "Generated ${bold}hardware-configuration.nix$normal at $bold~/hardware-configuration.nix$normal!"
''
