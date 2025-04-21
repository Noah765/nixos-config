{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.core.timeZone.enable = mkEnableOption "the German time zone";

  config.os.time.timeZone = mkIf config.core.timeZone.enable "Europe/Berlin";
}
