{ lib, config, ... }:
with lib;
let
  cfg = config.bootloader;
in
{
  options.bootloader.enable = mkEnableOption "bootloader";

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
