{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.walker;
in
{
  inputs.walker.url = "github:abenz1267/walker";

  hmImports = [ inputs.walker.homeManagerModules.default ];

  options.walker.enable = mkEnableOption "walker";

  config = mkIf cfg.enable {
    os.nix.settings = {
      substituters = [ "https://walker.cachix.org" ];
      trusted-public-keys = [ "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" ];
    };

    hm.programs.walker = {
      enable = true;
      runAsService = true;

      # TODO Clipboard module
      config = {
        placeholder = "Search...";
        enable_typeahead = true; # TODO It isn't showing up
        show_initial_entries = true;
        fullscreen = false; # TODO
        align.width = 400;
        list = {
          height = 300;
          margin_top = 10;
        };
        icons.size = 28;
        activation_mode.use_alt = true;
        modules = [
          { name = "applications"; }
          {
            name = "websearch";
            prefix = "?";
          }
          {
            name = "commands";
            prefix = ":";
          }
        ];
        external = [
          {
            name = "calculator";

            src_once =
              let
                script = pkgs.writeShellScriptBin "walker-calculator-start" ''
		  mkfifo /tmp/walker-calculator-input
		  mkfifo /tmp/walker-calculator-output

		  ${pkgs.kalker}/bin/kalker < /tmp/walker-calculator-input > /tmp/walker-calculator-output &
		'';
              in
              "${script}/bin/walker-calculator-start";

            src =
              let
                script = pkgs.writeShellScriptBin "walker-calculator" ''
                  echo "$1" > /tmp/walker-calculator-input
                  result=$(cat < /tmp/walker-calculator-output)

                  echo "[{
                    \"label\": \"$result\",
                    \"sub\": \"$1\",
                    \"searchable\": \"$1\",
                    \"score_final\": 100,
                  }]"
                '';
                #\"exec\": \"${execScript}/bin/walker-calculator-exec '$1; $result'\"
		#awk '{ print ", {'\
                #  '\"label\": \""$0"\",'\
                #  '\"searchable\": \"'"$1"'\",'\
                #  '\"score_final\": "NR" }" }' \
                #  /tmp/walker-calculator.kalker
                execScript = pkgs.writeShellScriptBin "walker-calculator-exec" ''
                  echo "$1" >> /tmp/walker-calculator.kalker
                  walker -m calculator
                '';
              in
              "${script}/bin/walker-calculator '%TERM%'";
          }
        ];
      };
    };
  };
}
