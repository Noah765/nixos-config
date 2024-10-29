{
  hm.programs.nixvim = {
    # TODO Is conform necessary, e.g. for the text to not jump around or to preserve marks and folds?
    plugins.conform-nvim = {
      enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";
        format_on_save.timeout_ms = 1000;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>f";
        action.__raw = "function() require('conform').format { async = true } end";
        options.desc = "Format buffer";
      }
    ];
  };
}
