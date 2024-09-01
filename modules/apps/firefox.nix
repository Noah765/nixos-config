{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.apps.firefox;
in {
  options.apps.firefox.enable = mkEnableOption "Firefox";

  config = mkIf cfg.enable {
    hm.programs.firefox = {
      enable = true;
      profiles.noah = {};
    };

    core.impermanence.hm.directories = [".mozilla/firefox/noah"];
    desktop.hyprland.settings.bind = ["Super, B, exec, firefox"];
  };
}
