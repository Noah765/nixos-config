{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.timeZone;
in {
  options.core.timeZone.enable = mkEnableOption "the German time zone";

  config.os.time.timeZone = "Europe/Berlin";
}
