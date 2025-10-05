{
  lib,
  config,
  ...
}: {
  imports = [(lib.mkAliasOptionModule ["cli" "editor" "linting" "lintersByFt"] ["cli" "editor" "settings" "plugins" "lint" "lintersByFt"])];

  options.cli.editor.linting.enable = lib.mkEnableOption "linting using nvim-lint";

  config.cli.editor.settings.plugins.lint.enable = lib.mkIf config.cli.editor.linting.enable true;
}
