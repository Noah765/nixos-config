{
  lib,
  pkgs,
  config,
  ...
}: {
  options.apps.signal.enable = lib.mkEnableOption "Signal";

  config = lib.mkIf config.apps.signal.enable {
    hm.home.packages = [pkgs.signal-desktop];
    core.impermanence.hm.directories = [".config/Signal"];
    desktop.hyprland.settings.bind = ["Super, S, exec, signal-desktop"];
  };
}
