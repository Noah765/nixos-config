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
      y.absolute = 15;
      width.fraction = 0.3;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = ''
      window {
        background: transparent;
      }
    '';
  };
}
