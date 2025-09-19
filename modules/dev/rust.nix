{
  lib,
  config,
  ...
}: {
  options.dev.rust.enable = lib.mkEnableOption "Rust";

  config = lib.mkIf config.dev.rust.enable {
    core.impermanence.hm.directories = [".cargo" ".rustup"];
    cli.editor.lsp.servers.rust_analyzer.enable = true;
  };
}
