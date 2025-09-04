{
  lib,
  pkgs,
  config,
  ...
}: {
  options.apps.slack.enable = lib.mkEnableOption "Slack";

  config = lib.mkIf config.apps.slack.enable {
    hm.home.packages = [pkgs.slack];
    core.impermanence.hm.directories = [".config/Slack"];
    desktop.hyprland.settings.bind = ["Super, S, exec, slack"];
  };
}
