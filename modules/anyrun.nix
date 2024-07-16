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

  options.anyrun.enable = mkEnableOption "docs";

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
        border-radius: 12px;
        padding: 8px;
      }

      list#main {
        margin-top: 0.5rem;
        border: 2px solid alpha(@accent_color, 0.5);
        border-radius: 12px;
      }

      row#plugin:first-child {
        margin-top: 0;
      }

      row#plugin {
        margin-top: 8px;
        padding: 0;
      }

      list#plugin {
        background: transparent;
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
