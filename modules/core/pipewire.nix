{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.pipewire;
in {
  options.core.pipewire.enable = mkEnableOption "the PipeWire multimedia framework";

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
