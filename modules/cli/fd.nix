{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.cli.fd;
in {
  options.cli.fd.enable = mkEnableOption "fd";

  config.hm.programs.fd.enable = mkIf cfg.enable true;
}
