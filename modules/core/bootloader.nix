{ lib, config, ... }:
with lib;
let
  cfg = config.bootloader;
in
{
  options.bootloader.enable = mkEnableOption "bootloader";

  config.os.boot.loader = mkIf cfg.enable {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
