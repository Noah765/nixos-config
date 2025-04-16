{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.core.timeZone;
in {
  options.core.timeZone.enable = mkEnableOption "the German time zone";

  config.os.time.timeZone = mkIf cfg.enable "Europe/Berlin";
}
