{
  lib,
  config,
  ...
}: {
  options.dev.flutter.enable = lib.mkEnableOption "Flutter";

  config.core.impermanence.hm.directories = lib.mkIf config.dev.flutter.enable [".pub-cache"];
}
