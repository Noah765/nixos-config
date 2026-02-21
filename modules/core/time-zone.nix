{lib, ...}: {
  nixos = {config, ...}: {
    options.core.timeZone.enable = lib.mkEnableOption "the German time zone";

    config.time.timeZone = lib.mkIf config.core.timeZone.enable "Europe/Berlin";
  };
}
