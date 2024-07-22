{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.localisation;
in {
  options.localisation.enable = mkEnableOption "localisation";

  config = mkIf cfg.enable {
    os = {
      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_NZ.UTF-8";
      console.keyMap = "de-latin1-nodeadkeys";
    };

    desktop.hyprland.settings.input = mkIf cfg.enable {
      kb_layout = "de";
      kb_variant = "nodeadkeys";
    };
  };
}
