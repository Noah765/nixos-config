{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.cli.ripgrep.enable = mkEnableOption "ripgrep";

  config.hm.programs.ripgrep.enable = mkIf config.cli.ripgrep.enable true;
}
