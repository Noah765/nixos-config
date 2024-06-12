pkgs:
pkgs.writeShellScriptBin "download" ''
  sudo git clone https://github.com/Noah765/dots  ~/dots

  bold=$'\033[1m'
  normal=$'\033[0m'
  echo $'\n'"Successfully downloaded the dots into $bold~/dots$normal!"
''
