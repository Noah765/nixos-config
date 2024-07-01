{ lib, config, ... }:
with lib;
let
  cfg = config.localization;
in
{
  options.localization.enable = mkEnableOption "localization";

  config.hyprland.settings.input = mkIf cfg.enable {
    kb_layout = "de";
    kb_variant = "nodeadkeys";
  };
}
