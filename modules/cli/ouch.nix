{
  lib,
  pkgs,
  config,
  ...
}: {
  options.cli.ouch.enable = lib.mkEnableOption "ouch";

  config.hm.home.packages = lib.mkIf config.cli.ouch.enable [pkgs.ouch];
}
