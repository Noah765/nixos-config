{lib, ...}: {
  nixos = {config, ...}: {
    options.dev.dart.enable = lib.mkEnableOption "Dart";

    config.core.impermanence.hm.directories = lib.mkIf config.dev.dart.enable [".pub-cache"];
  };
}
