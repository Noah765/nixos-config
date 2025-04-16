{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.core.boot;
in {
  options.core.boot.enable = mkEnableOption "the default boot configuration";

  config.os.boot = mkIf cfg.enable {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.enable = true;
  };
}
