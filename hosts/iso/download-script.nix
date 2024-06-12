pkgs:
pkgs.writeShellScriptBin "download" ''
  sudo git clone https://github.com/Noah765/dots  ~/dots

  bold=$'\033[1m'
  normal=$'\033[0m'
  echo "Downloaded the dots into $bold~/dots$normal!"
''
