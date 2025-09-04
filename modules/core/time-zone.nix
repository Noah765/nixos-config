{
  lib,
  config,
  ...
}: {
  options.core.timeZone.enable = lib.mkEnableOption "the German time zone";

  config.os.time.timeZone = lib.mkIf config.core.timeZone.enable "Europe/Berlin";
}
