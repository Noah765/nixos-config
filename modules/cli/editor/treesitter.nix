{
  lib,
  config,
  ...
}: {
  imports = [(lib.mkAliasOptionModule ["cli" "editor" "treesitter" "grammars"] ["cli" "editor" "settings" "plugins" "treesitter" "grammarPackages"])];

  options.cli.editor.treesitter.enable = lib.mkEnableOption "Treesitter";

  config.cli.editor.settings.plugins.treesitter = lib.mkIf config.cli.editor.treesitter.enable {
    enable = true;
    settings.highlight.enable = true;
    settings.indent.enable = true;
  };
}
