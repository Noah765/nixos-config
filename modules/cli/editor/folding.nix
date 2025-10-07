{
  lib,
  config,
  ...
}: {
  options.cli.editor.folding.enable = lib.mkEnableOption "folding using nvim-origami";

  config.cli.editor.settings = lib.mkIf config.cli.editor.folding.enable {
    plugins.origami.enable = true;
    opts.foldcolumn = "1";
    opts.foldlevel = 99;
  };
}
