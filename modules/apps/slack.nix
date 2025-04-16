{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.apps.slack;
in {
  options.apps.slack.enable = mkEnableOption "Slack";

  config = mkIf cfg.enable {
    hm.home.packages = [pkgs.slack];
    core.impermanence.hm.directories = [".config/Slack"];
    desktop.hyprland.settings.bind = ["Super, S, exec, slack"];
  };
}
