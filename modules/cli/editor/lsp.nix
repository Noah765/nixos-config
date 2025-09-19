{
  lib,
  config,
  ...
}: {
  imports = [(lib.mkAliasOptionModule ["cli" "editor" "lsp" "servers"] ["cli" "editor" "settings" "lsp" "servers"])];

  options.cli.editor.lsp.enable = lib.mkEnableOption "lsp";

  config.cli.editor.settings.plugins.lspconfig.enable = lib.mkIf config.cli.editor.lsp.enable true;
}
