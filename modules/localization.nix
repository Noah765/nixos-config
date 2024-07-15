{ lib, config, ... }:
with lib;
let
  cfg = config.localization;
in
{
  options.localization.enable = mkEnableOption "localization";

  config = mkIf cfg.enable {
    os = {
      time.timeZone = "Europe/Berlin";

      i18n = {
        defaultLocale = "en_NZ.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "de_DE.UTF-8";
          LC_IDENTIFICATION = "de_DE.UTF-8";
          LC_MEASUREMENT = "de_DE.UTF-8";
          LC_MONETARY = "de_DE.UTF-8";
          LC_NAME = "de_DE.UTF-8";
          LC_NUMERIC = "de_DE.UTF-8";
          LC_PAPER = "de_DE.UTF-8";
          LC_TELEPHONE = "de_DE.UTF-8";
          LC_TIME = "de_DE.UTF-8";
        };
      };

      console.keyMap = "de-latin1-nodeadkeys";
    };

    hyprland.settings.input = mkIf cfg.enable {
      kb_layout = "de";
      kb_variant = "nodeadkeys";
    };
  };
}
