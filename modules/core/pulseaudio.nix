{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.pulseaudio;
in {
  options.core.pulseaudio.enable = mkEnableOption "PulseAudio";

  config.os.hardware.pulseaudio = mkIf cfg.enable {
    enable = true;
    support32Bit = true;
  };
}
