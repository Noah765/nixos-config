{
  lib,
  config,
  ...
}: {
  options.cli.editor.telescope.enable = lib.mkEnableOption "Telescope";

  config.cli.editor.settings = lib.mkIf config.cli.editor.telescope.enable {
    dependencies.ripgrep.enable = true;

    plugins.which-key.settings.spec = lib.singleton (config.hm.lib.nixvim.utils.listToUnkeyedAttrs ["<leader>p"] // {group = "Picker";});

    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>pf" = {
          action = "find_files";
          options.desc = "Files";
        };
        "<leader>pF" = {
          action = "current_buffer_fuzzy_find";
          options.desc = "Buffer";
        };
        "<leader>pg" = {
          action = "live_grep";
          options.desc = "Grep";
        };
        "<leader>ph" = {
          action = "help_tags";
          options.desc = "Help tags";
        };
        "<leader>pH" = {
          action = "search_history";
          options.desc = "History";
        };
        "<leader>pm" = {
          action = "marks";
          options.desc = "Marks";
        };
        "<leader>pq" = {
          action = "quickfix";
          options.desc = "Quickfix";
        };
        "<leader>pr" = {
          action = "resume";
          options.desc = "Resume";
        };
        "<leader>pR" = {
          action = "registers";
          options.desc = "Registers";
        };
        "<leader>ps" = {
          action = "lsp_document_symbols";
          options.desc = "Document symbols";
        };
        "<leader>pS" = {
          action = "lsp_workspace_symbols";
          options.desc = "Workspace symbols";
        };
      };
    };
  };
}
