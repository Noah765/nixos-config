{ lib, config, ... }:
with lib;
let
  cfg = config.localization;
in
{
  options.localization.enable = mkEnableOption "localization";

  config.hyprland.config.input = mkIf cfg.enable {
    kb_layout = "de";
    kb_variant = "nodeadkeys";
  };
}
