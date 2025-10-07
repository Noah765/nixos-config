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

    dev.formatters.typ = "typst-fmt";

    cli.editor = {
      lsp.servers.tinymist.enable = true;
      lsp.servers.tinymist.settings.on_attach = config.hm.lib.nixvim.utils.mkRaw ''
        function(client, bufnr)
          vim.keymap.set("n", "<leader>lP", function()
            client:exec_cmd({
              title = "pin",
              command = "tinymist.pinMain",
              arguments = { vim.api.nvim_buf_get_name(0) },
            }, { bufnr = bufnr })
          end, { desc = "Tinymist pin", noremap = true })

          vim.keymap.set("n", "<leader>lU", function()
            client:exec_cmd({
              title = "unpin",
              command = "tinymist.pinMain",
              arguments = { vim.v.null },
            }, { bufnr = bufnr })
          end, { desc = "Tinymist unpin", noremap = true })
        end
      '';

      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.typst];

      settings.plugins.typst-preview = {
        enable = true;
        settings.open_cmd = "qutebrowser --target window --loglevel warning %s";
        settings.invert_colors = "auto";
      };
      settings.files."ftplugin/typst.lua".keymaps = lib.singleton {
        key = "<leader>lp";
        mode = "n";
        action = "<cmd>TypstPreview<CR>";
        options.buffer = config.hm.lib.nixvim.utils.mkRaw "vim.api.nvim_get_current_buf()";
        options.desc = "Live preview";
      };
    };
  };
}
