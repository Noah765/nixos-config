{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.java.enable = lib.mkEnableOption "Java";

  config = lib.mkIf config.dev.java.enable {
    dev.formatters.java = "java-fmt";

    cli.editor.lsp.servers.jdtls.enable = true;
    cli.editor.treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.java];
  };
}
