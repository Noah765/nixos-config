{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.slack;
in {
  options.slack.enable = mkEnableOption "slack";

  config = mkIf cfg.enable {
    hm.home.packages = [pkgs.slack];
    impermanence.hm.directories = [".config/Slack"];
  };
}
