{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.core.nvidia;
in {
  options.core.nvidia.enable = mkEnableOption "Nvidia drivers";

  config.os = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"]; # This does not enable xserver, the name is historical

    hardware.nvidia = {
      open = false;
      nvidiaSettings = false; # Configuration app
      powerManagement.enable = true;
    };
  };
}
