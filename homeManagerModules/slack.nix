{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.slack;
in
{
  options.slack.enable = mkEnableOption "slack";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.slack ];
    impermanence.directories = [ ".config/Slack" ];
  };
}
