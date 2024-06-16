pkgs:
pkgs.writeShellScriptBin "wifi" ''
  set -euo pipefail

  ssid=$(nmcli -f ssid,mode,chan,rate,signal,bars,security device wifi | fzf --border --border-label 'Network selection' --prompt 'Network> ' --header-lines 1 | cut -d ' ' -f1)
  echo -e "\nSSID: $ssid"
  nmcli device wifi connect "$ssid" --ask

  bold=$'\033[1m'
  normal=$'\033[0m'
  echo -e "\nSuccessfully connected to the WIFI network $bold$ssid$normal!"
''
