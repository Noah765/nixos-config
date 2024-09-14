{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.pulseaudio;
in {
  options.core.pulseaudio.enable = mkEnableOption "PulseAudio";

  # TODO Switch to PipeWire when moving away from waybar
  config.os = mkIf cfg.enable {
    hardware.pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    services.pipewire.enable = false;
  };
}
