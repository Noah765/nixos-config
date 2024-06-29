{ lib, config, ... }:
with lib;
let
  cfg = config.localization;
in
{
  options.localization.enable = mkEnableOption "localization";

  config = mkIf cfg.enable {
    hyprland.settings.input = {
      kb_layout = "de";
      kb_variant = "nodeadkeys";
    };
  };
}
