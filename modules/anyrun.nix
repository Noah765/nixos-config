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

      list#main {
        margin-top: 0.5rem; 
        border: 1px solid @theme_bg_color;
      }

      /*
      #match.activatable {
          border-radius: 16px;
          padding: 0.3rem 0.9rem;
          margin-top: 0.01rem;
      }
      #match.activatable:first-child {
          margin-top: 0.0rem;
      }
      #match.activatable:last-child {
          margin-bottom: 0.6rem;
      }

      #entry {
          border: 1px solid #0b0f10;
          border-radius: 16px;
          margin: 0.5rem;
          padding: 0.3rem 1rem;
      }

      list > #plugin {
          margin: 0 0.3rem;
      }
      list > #plugin:first-child {
          margin-top: 0.3rem;
      }
      list > #plugin:last-child {
          margin-bottom: 0.3rem;
      }
      */
    '';
  };
}
