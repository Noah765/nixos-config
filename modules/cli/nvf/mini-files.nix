{
  lib,
  config,
  ...
}: let
  excludedEntries = [".dart_tool" ".direnv" ".flutter-plugins" ".flutter-plugins-dependencies" ".git" ".idea" ".jj" ".metadata" "build" "target"];
  excludedSuffixes = ["iml" "lock"];
  filterFunction = ''
    function(fs_entry)
      local is_in_excluded_entries = vim.list_contains(${lib.generators.toLua {} excludedEntries}, fs_entry.name)
      local ends_with_excluded_suffix = vim.list_contains(${lib.generators.toLua {} excludedSuffixes}, vim.iter(vim.gsplit(fs_entry.name, '.', { plain = true })):last())
      return MiniFiles.show_all or not is_in_excluded_entries and not ends_with_excluded_suffix
    end
  '';
in {
  options.cli.nvf.mini-files.enable = lib.mkEnableOption "mini.files";

  config.cli.nvf.settings = lib.mkIf config.cli.nvf.mini-files.enable {
    mini.files.enable = true; # TODO Show help inside which-key
    mini.files.setupOpts = {
      content.filter = lib.mkLuaInline filterFunction;
      mappings.close = "<Esc>";
      windows = {
        preview = true;
        width_focus = 30;
        width_preview = 60;
      };
    };
    keymaps = [
      {
        key = "<leader>e";
        mode = "n";
        action = "MiniFiles.open";
        lua = true;
        desc = "File explorer";
      }
      {
        key = "<leader>th";
        mode = "n";
        action = ''
          function()
            MiniFiles.show_all = not MiniFiles.show_all
            MiniFiles.refresh({ content = { filter = ${filterFunction} } })
          end
        '';
        lua = true;
        desc = "Toggle hidden [mini.files]";
      }
    ];
    autocmds = [
      {
        event = ["User"];
        pattern = ["MiniFilesExplorerOpen"];
        callback = lib.mkLuaInline ''
          function()
            MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
            MiniFiles.set_bookmark('~', '~', { desc = 'Home' })
          end
        '';
      }
      {
        event = ["User"];
        pattern = ["MiniFilesBufferCreate"];
        callback = lib.mkLuaInline ''
          function(args)
            local function yank_path()
              local path = (MiniFiles.get_fs_entry() or {}).path
              if path == nil then return vim.notify('Cursor is not on a valid file system entry', vim.log.levels.WARN) end
              vim.fn.setreg(vim.v.register, path)
            end

            local function set_cwd()
              local path = (MiniFiles.get_fs_entry() or {}).path
              if path == nil then return vim.notify('Cursor is not on a valid file system entry', vim.log.levels.WARN) end
              vim.fn.chdir(vim.fs.dirname(path))
              MiniFiles.close()
              MiniFiles.open()
            end

            local function open() vim.ui.open(MiniFiles.get_fs_entry().path) end

            local function split(command)
              local fs_type = (MiniFiles.get_fs_entry() or {}).fs_type
              if fs_type == nil then return vim.notify('Cursor is not on a valid file system entry', vim.log.levels.WARN) end
              if fs_type == 'directory' then return vim.notify('Cursor is on a directory', vim.log.levels.WARN) end

              local current_target = MiniFiles.get_explorer_state().target_window
              local new_target = vim.api.nvim_win_call(current_target, function()
                vim.cmd(command)
                return vim.api.nvim_get_current_win()
              end)
              MiniFiles.set_target_window(new_target)

              MiniFiles.go_in()
            end

            local buf_id = args.data.buf_id
            vim.keymap.set('n', '<CR>',  function() MiniFiles.go_in({ close_on_file = true }) end, { buffer = buf_id, desc = 'Go in entry plus' })
            vim.keymap.set('n', 'gy',    yank_path,                                                { buffer = buf_id, desc = 'Yank path' })
            vim.keymap.set('n', 'g~',    set_cwd,                                                  { buffer = buf_id, desc = 'Set cwd' })
            vim.keymap.set('n', 'gx',    open,                                                     { buffer = buf_id, desc = 'OS open' })
            vim.keymap.set('n', '<C-h>', function() split('split') end,                            { buffer = buf_id, desc = 'Split horizontal' })
            vim.keymap.set('n', '<C-s>', function() split('vsplit') end,                           { buffer = buf_id, desc = 'Split vertical' })
            vim.keymap.set('n', '<C-t>', function() split('tab split') end,                        { buffer = buf_id, desc = 'Split tab' })
          end
        '';
      }
    ];
  };
}
