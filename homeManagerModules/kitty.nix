{ lib, config, ... }:
with lib;
let
  cfg = config.kitty;
in
{
  options.kitty.enable = mkEnableOption "kitty";

  config = mkIf cfg.enable {
    programs.kitty.enable = true;
    home.sessionVariables = {
      TERMINAL = "kitty";
    };
  };
}
