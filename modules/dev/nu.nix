{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.nu.enable = lib.mkEnableOption "Nu";

  config.cli.editor = lib.mkIf config.dev.nu.enable {
    lsp.servers.nushell.enable = true;
    treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.nu];
  };
}
