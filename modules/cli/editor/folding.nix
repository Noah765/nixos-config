{
  lib,
  config,
  ...
}: {
  options.cli.editor.folding.enable = lib.mkEnableOption "folding using nvim-ufo";

  config.cli.editor.settings = lib.mkIf config.cli.editor.folding.enable {
    plugins.nvim-ufo.enable = true;
    plugins.nvim-ufo.settings = {
      close_fold_kinds_for_ft.default = ["comment" "imports"];
      preview.win_config.maxheight = 50;
    };

    opts.foldcolumn = "1";
    opts.foldlevel = 99;

    keymaps = [
      {
        key = "zR";
        mode = "n";
        action = config.hm.lib.nixvim.utils.mkRaw "require('ufo').openAllFolds";
      }
      {
        key = "zM";
        mode = "n";
        action = config.hm.lib.nixvim.utils.mkRaw "require('ufo').closeAllFolds";
      }
      {
        key = "zr";
        mode = "n";
        action = config.hm.lib.nixvim.utils.mkRaw "require('ufo').openFoldsExceptKinds";
        options.desc = "Open folds except default";
      }
      {
        key = "zm";
        mode = "n";
        action = config.hm.lib.nixvim.utils.mkRaw "require('ufo').closeFoldsWith";
        options.desc = "Close folds to level";
      }
      {
        key = "zp";
        mode = "n";
        action = config.hm.lib.nixvim.utils.mkRaw "require('ufo').peekFoldedLinesUnderCursor";
        options.desc = "Preview fold";
      }
    ];
  };
}
