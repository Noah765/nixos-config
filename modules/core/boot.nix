{
  lib,
  config,
  ...
}: {
  options.core.boot.enable = lib.mkEnableOption "the default boot configuration";

  config.os.boot.loader = lib.mkIf config.core.boot.enable {
    systemd-boot.enable = true; # TODO Configure and style systemd-boot
    efi.canTouchEfiVariables = true;
  };
}
