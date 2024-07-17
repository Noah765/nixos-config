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
            src =
              let
                script = pkgs.writeShellScriptBin "walker-calculator" ''
                  result=$(${pkgs.kalker}/bin/kalker -i /tmp/walker-calculator.kalker "$1" 2>&1)

                  echo "[
		    {
                      \"label\": \"$result\",
                      \"searchable\": \"$1\",
                      \"exec\": \"echo '$result' >> /tmp/walker-calculator.kalker; walker\"
                    }
		  ]"
                '';
              in
              "${script}/bin/walker-calculator '%TERM%'";
          }
        ];
      };
    };
  };
}
