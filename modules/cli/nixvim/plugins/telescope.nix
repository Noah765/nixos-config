{
  dependencies = ["cli.fd"];

  hm.programs.nixvim = {
    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
      keymaps = {
        "<leader>sh" = {
          action = "help_tags";
          options.desc = "Search Help";
        };
        "<leader>sk" = {
          action = "keymaps";
          options.desc = "Search Keymaps";
        };
        "<leader>sf" = {
          action = "find_files";
          options.desc = "Search Files";
        };
        # TODO Remove if this is never used
        "<leader>sw" = {
          action = "grep_string";
          options.desc = "Search current word";
        };
        "<leader>sg" = {
          action = "live_grep";
          options.desc = "Search by Grep";
        };
        # TODO Remove if this is never used
        "<leader>sr" = {
          action = "resume";
          options.desc = "Resume search";
        };
        # TODO Remove if this is never used
        "<leader>s." = {
          action = "oldfiles";
          options.desc = "Search recent files";
        };
        "<leader><leader>" = {
          action = "buffers";
          options.desc = "Find existing buffers";
        };
      };
      settings.defaults.mappings = {
        i = {
          "<C-r>" = "select_vertical";
          "<C-s>" = "select_horizontal";
        };
        n = {
          "<C-r>" = "select_vertical";
          "<C-s>" = "select_horizontal";
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>/";
        action.__raw = ''
          function()
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
          end
        '';
        options.desc = "Fuzzily search in current buffer";
      }
      {
        mode = "n";
        key = "<leader>s/";
        action.__raw = ''
          function()
            require('telescope.builtin').live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
            }
          end
        '';
        options.desc = "Search in open files";
      }
    ];
  };
}
