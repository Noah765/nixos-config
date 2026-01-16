{
  lib,
  config,
  ...
}: {
  options.dev.dart.enable = lib.mkEnableOption "Dart";

  config = lib.mkIf config.dev.dart.enable {
    core.impermanence.hm.directories = [".pub-cache"];
    cli.editor.languages.dart.language-servers = ["dart" "codebook"];
  };
}
