pkgs:
pkgs.writeShellScriptBin "generate" ''
  set -euo pipefail

  sudo nixos-generate-config --no-filesystems --show-hardware-config > ~/hardware-configuration.nix

  bold=$'\033[1m'
  normal=$'\033[0m'
  echo "Successfully generated ''${bold}hardware-configuration.nix$normal at $bold~/hardware-configuration.nix$normal!"
''
