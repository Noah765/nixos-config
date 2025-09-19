{
  lib,
  config,
  ...
}: {
  options.dev.flutter.enable = lib.mkEnableOption "Flutter";

  config = lib.mkIf config.dev.flutter.enable {
    core.impermanence.hm.directories = [".pub-cache"];
    cli.editor.lsp.servers.dartls.enable = true;
  };
}
