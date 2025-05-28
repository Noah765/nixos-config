{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.dev.flutter.enable = mkEnableOption "Flutter";

  config.core.impermanence.hm.directories = mkIf config.dev.flutter.enable [".pub-cache"];
}
