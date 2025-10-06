{
  lib,
  config,
  ...
}: {
  imports = [(lib.mkAliasOptionModule ["cli" "editor" "lsp" "servers"] ["cli" "editor" "settings" "lsp" "servers"])];

  options.cli.editor.lsp.enable = lib.mkEnableOption "lsp";

  config = lib.mkIf config.cli.editor.lsp.enable {
    dependencies = ["cli.editor.telescope"];

    cli.editor.settings.plugins.lspconfig.enable = true;

    cli.editor.settings.lsp.keymaps = [
      {
        key = "<leader>j";
        mode = "n";
        action = config.hm.lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = 1, float = true }) end";
        options.desc = "Next diagnostic";
      }
      {
        key = "<leader>k";
        mode = "n";
        action = config.hm.lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = -1, float = true }) end";
        options.desc = "Previous diagnostic";
      }
      {
        key = "<leader>lD";
        mode = "n";
        action = config.hm.lib.nixvim.mkRaw "require('telescope.builtin').diagnostics";
        options.desc = "Diagnostics";
      }
      {
        key = "<leader>lt";
        mode = "n";
        action = config.hm.lib.nixvim.mkRaw "require('telescope.builtin').lsp_type_definitions";
        options.desc = "Type definitions";
      }
      {
        key = "<leader>ld";
        mode = "n";
        action = config.hm.lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
        options.desc = "Definitions";
      }
      {
        key = "<leader>li";
        mode = "n";
        action = config.hm.lib.nixvim.mkRaw "require('telescope.builtin').lsp_implementations";
        options.desc = "Implementations";
      }
      {
        key = "<leader>lr";
        mode = "n";
        action = config.hm.lib.nixvim.mkRaw "require('telescope.builtin').lsp_references";
        options.desc = "References";
      }
    ];
  };
}
