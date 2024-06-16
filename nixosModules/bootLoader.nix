{ lib, config, ... }:
with lib;
let
  cfg = config.bootLoader;
in
{
  options.bootLoader.enable = mkEnableOption "boot loader";

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
