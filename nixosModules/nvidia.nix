{ lib, config, ... }:
with lib;
let
  cfg = config.nvidia;
in
{
  options.nvidia.enable = mkEnableOption "nvidia";

  config = mkIf cfg.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ]; # This does not enable xserver, the name is historical

    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false; # Configuration app
    };
  };
}
