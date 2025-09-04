{
  lib,
  config,
  ...
}: {
  options.core.nvidia.enable = lib.mkEnableOption "Nvidia drivers";

  config.os = lib.mkIf config.core.nvidia.enable {
    services.xserver.videoDrivers = ["nvidia"]; # This does not enable xserver, the name is historical

    hardware.nvidia = {
      open = false;
      nvidiaSettings = false; # Configuration app
      powerManagement.enable = true;
    };
  };
}
