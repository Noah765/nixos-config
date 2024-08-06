{
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  cfg = config.core.ddccontrol;
in {
  options.core.ddccontrol.enable = mkEnableOption "ddccontrol for controlling displays";

  config.os = mkIf cfg.enable {
    services.ddccontrol.enable = true;
    boot.extraModulePackages = [osConfig.boot.kernelPackages.ddcci-driver];
  };
}
