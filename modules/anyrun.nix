{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.anyrun;
in
{
  inputs.anyrun.url = "github:anyrun-org/anyrun";

  hmImports = [ inputs.anyrun.homeManagerModules.default ];

  options.anyrun.enable = mkEnableOption "anyrun";

  config.hm.programs.anyrun = mkIf cfg.enable {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
      ];
      y.absolute = 30;
      width.fraction = 0.3;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = ''
      #window {
        background: transparent;
      }

      #entry {
        border: 2px solid alpha(@accent_color, 0.5);
        border-radius: 12px;
        box-shadow: none;
        padding: 8px;
      }

      list#main {
        margin-top: 16px;
        border: 2px solid alpha(@accent_color, 0.5);
        border-radius: 12px;
      }

      row#plugin:first-child {
        margin-top: 0;
      }

      row#plugin {
        margin-top: 8px;
        padding: 0;
        outline: 0;
        background: 0;
      }

      list#plugin {
        background: 0;
      }

      row#plugin:first-child row#match:first-child {
        border-radius: 8px 8px 0 0;
      }
      row#plugin:last-child row#match:last-child {
        border-radius: 0 0 8px 8px;
      }

      row#match {
        padding: 8px;
      }

      label#match-desc {
        font-size: 8pt;
      }
    '';
  };
}
