{ lib, config, ... }:
with lib;
let
  cfg = config.audio;
in
{
  options.audio.enable = mkEnableOption "audio";

  config.os = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
