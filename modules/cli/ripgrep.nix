{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.cli.ripgrep;
in {
  options.cli.ripgrep.enable = mkEnableOption "ripgrep";

  config.hm.programs.ripgrep.enable = mkIf cfg.enable true;
}
