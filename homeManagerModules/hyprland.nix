{
  osConfig,
  lib,
  options,
  config,
  ...
}:
with lib;
let
  cfg = config.hyprland;
in
{
  options.hyprland = {
    enable = mkEnableOption "hyprland";
    settings = options.wayland.windowManager.hyprland.settings;
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.hyprland.enable;
        message = "The NixOS hyprland module is required for the home manager hyprland module.";
      }
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = cfg.settings;
    };
  };
}
