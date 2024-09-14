{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.nvidia;
in {
  options.core.nvidia.enable = mkEnableOption "Nvidia drivers";

  config.os = mkIf cfg.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = ["nvidia"]; # This does not enable xserver, the name is historical

    hardware.nvidia = {
      open = false;
      nvidiaSettings = false; # Configuration app
    };
  };
}
