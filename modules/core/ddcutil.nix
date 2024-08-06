{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; let
  cfg = config.core.ddcutil;
in {
  options.core.ddcutil.enable = mkEnableOption "ddcutil for controlling displays";

  config = mkIf cfg.enable {
    os.hardware.i2c.enable = true;
    core.user.groups = ["i2c"];

    hm.home.packages = [pkgs.ddcutil];
    os.boot = {
      extraModulePackages = [osConfig.boot.kernelPackages.ddcci-driver];
      kernelModules = ["ddcci_backlight"]; # TODO Needed?
    };
  };
}
