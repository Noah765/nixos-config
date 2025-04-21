{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.cli.fd.enable = mkEnableOption "fd";

  config.hm.programs.fd.enable = mkIf config.cli.fd.enable true;
}
