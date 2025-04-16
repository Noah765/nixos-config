{
  lib,
  pkgs,
  ...
}:
with lib; {
  hm.programs.nixvim = {
    # TODO Is conform necessary, e.g. for the text to not jump around or to preserve marks and folds?
    plugins.conform-nvim = {
      enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";
        format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 1000 }
          end
        '';
        formatters_by_ft.yaml = ["yamlfmt"];
        formatters.yamlfmt.command = getExe pkgs.yamlfmt;
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
    userCommands = {
      FormatDisable = {
        desc = "Disable autoformat on save";
        command = "let g:disable_autoformat = 1";
      };
      FormatDisableBuffer = {
        desc = "Disable autoformat on save for the current buffer";
        command = "let b:disable_autoformat = 1";
      };
      FormatEnable = {
        desc = "Enable autoformat on save";
        command = "let g:disable_autoformat = 0";
      };
      FormatEnableBuffer = {
        desc = "Enable autoformat on save for the current buffer";
        command = "let b:disable_autoformat = 0";
      };
    };
  };
}
