{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cli.ripgrep;
in {
  options.cli.ripgrep.enable = mkEnableOption "ripgrep";

  config.hm.programs.ripgrep.enable = mkIf cfg.enable true;
}
