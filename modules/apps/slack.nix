{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.apps.slack.enable = mkEnableOption "Slack";

  config = mkIf config.apps.slack.enable {
    hm.home.packages = [pkgs.slack];
    core.impermanence.hm.directories = [".config/Slack"];
    desktop.hyprland.settings.bind = ["Super, S, exec, slack"];
  };
}
