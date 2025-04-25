{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.dev.flutter.enable = mkEnableOption "Flutter";

  config = mkIf config.dev.flutter.enable {
    hm.home.packages = [pkgs.flutter];
    core.impermanence.hm.directories = [".pub-cache"];
  };
}
