{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.typst.enable = lib.mkEnableOption "Typst";

  config = lib.mkIf config.dev.typst.enable {
    dependencies = ["apps.browser"];

    core.impermanence.hm.directories = [".cache/typst"];

    cli.vcs.jj.fix.typst-fmt = {
      command = "typst-fmt";
      patterns = ["glob:**/*.typ"];
    };

    cli.editor = {
      lsp.servers.tinymist.enable = true;
      lsp.servers.tinymist.settings.on_attach = config.hm.lib.nixvim.utils.mkRaw ''
        function(client, bufnr)
          vim.keymap.set("n", "<leader>lp", function()
            client:exec_cmd({
              title = "pin",
              command = "tinymist.pinMain",
              arguments = { vim.api.nvim_buf_get_name(0) },
            }, { bufnr = bufnr })
          end, { desc = "Tinymist pin", noremap = true })

          vim.keymap.set("n", "<leader>lu", function()
            client:exec_cmd({
              title = "unpin",
              command = "tinymist.pinMain",
              arguments = { vim.v.null },
            }, { bufnr = bufnr })
          end, { desc = "Tinymist unpin", noremap = true })
        end
      '';

      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.typst];

      formatting.formatters.typst-fmt.command = "typst-fmt";
      formatting.formattersByFt.typst = ["typst-fmt"];

      settings.plugins.typst-preview = {
        enable = true;
        settings.open_cmd = "qutebrowser --target window --loglevel warning %s";
        settings.invert_colors = "auto";
      };
      settings.files."ftplugin/typst.lua" = {
        opts.textwidth = 100;
        keymaps = lib.singleton {
          key = "<leader>d";
          mode = "n";
          action = "<cmd>TypstPreview<CR>";
          options.desc = "Live preview";
        };
      };
    };
  };
}
