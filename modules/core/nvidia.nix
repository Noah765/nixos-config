{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.core.nvidia.enable = mkEnableOption "Nvidia drivers";

  config.os = mkIf config.core.nvidia.enable {
    services.xserver.videoDrivers = ["nvidia"]; # This does not enable xserver, the name is historical

    hardware.nvidia = {
      open = false;
      nvidiaSettings = false; # Configuration app
      powerManagement.enable = true;
    };
  };
}
