{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.systemd-boot;
in {
  options.core.systemd-boot.enable = mkEnableOption "the systemd-boot EFI boot manager";

  config.os.boot.loader = mkIf cfg.enable {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
