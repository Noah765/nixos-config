{
  lib,
  inputs,
  pkgs,
  config,
  hmConfig,
  ...
}:
# TODO Remove if unused
with lib;
with hmConfig.lib.nixvim; let
  cfg = config.cli.neovim;
in {
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
      nuschtosSearch.follows = "";
      nix-darwin.follows = "";
      devshell.follows = "";
      treefmt-nix.follows = "";
      flake-compat.follows = "";
      git-hooks.follows = "";
    };
  };

  hmImports = [inputs.nixvim.homeManagerModules.default];

  options.cli.neovim.enable = mkEnableOption "Neovim";

  config.hm.programs.nixvim = mkIf cfg.enable {
    enable = true;
    defaultEditor = true;
    # TODO vimdiffAlias, luaLoader

    extraPackages = [pkgs.stylua];
    extraPlugins = [pkgs.vimPlugins.nvim-web-devicons]; # TODO Is this enabled by default?
    extraConfigLua = ''
      require('mini.statusline').section_location = function()
        return '%2l:%-2v'
      end
    '';

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
      showmode = false;
      clipboard = "unnamedplus"; # TODO Schedule?
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
    };

    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
        options.desc = "Move focus to the left window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
        options.desc = "Move focus to the right window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
        options.desc = "Move focus to the lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        options.desc = "Move focus to the upper window";
      }

      # TODO Group with telescope keymaps
      # TODO Formatter for stringified lua code
      {
        mode = "n";
        key = "<leader>/";
        action = mkRaw ''
          function()
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
          end
        '';
        options.desc = "[/] Fuzzily search in current buffer";
      }
      {
        mode = "n";
        key = "<leader>s/";
        action = mkRaw ''
          function()
            require('telescope.builtin').live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
            }
          end
        '';
        options.desc = "[S]earch [/] in Open Files";
      }
      {
        mode = "n";
        key = "<leader>sn";
        action = mkRaw ''
          function()
            require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
          end
        '';
        options.desc = "[S]earch [N]eovim files";
      }

      # TODO Group with conform plugin config
      {
        key = "<leader>f";
        action = mkRaw ''
          function()
            require('conform').format { async = true, lsp_fallback = true }
          end
        '';
        options.desc = "[F]ormat buffer";
      }
    ];

    autoGroups.kickstart-highlight-yank = {};

    autoCmd = [
      {
        event = "TextYankPost";
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback = mkRaw "function() vim.highlight.on_yank() end";
      }
    ];

    plugins = {
      sleuth.enable = true;

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };
      };

      # TODO Deferred loading?
      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed = "<leader>c";
            group = "[C]ode";
          }
          {
            __unkeyed = "<leader>d";
            group = "[D]ocument";
          }
          {
            __unkeyed = "<leader>r";
            group = "[R]ename";
          }
          {
            __unkeyed = "<leader>s";
            group = "[S]earch";
          }
          {
            __unkeyed = "<leader>w";
            group = "[W]orkspace";
          }
          {
            __unkeyed = "<leader>t";
            group = "[T]oggle";
          }
          {
            __unkeyed = "<leader>h";
            group = "Git [H]unk";
            mode = ["n" "v"];
          }
        ];
      };

      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        keymaps = {
          "<leader>sh" = {
            action = "help_tags";
            options.desc = "[S]earch [H]elp";
          };
          "<leader>sk" = {
            action = "keymaps";
            options.desc = "[S]earch [K]eymaps";
          };
          "<leader>sf" = {
            action = "find_files";
            options.desc = "[S]earch [F]iles";
          };
          "<leader>ss" = {
            action = "builtin";
            options.desc = "[S]earch [S]elect Telescope";
          };
          "<leader>sw" = {
            action = "grep_string";
            options.desc = "[S]earch current [W]ord";
          };
          "<leader>sg" = {
            action = "live_grep";
            options.desc = "[S]earch by [G]rep";
          };
          "<leader>sd" = {
            action = "diagnostics";
            options.desc = "[S]earch [D]iagnostics";
          };
          "<leader>sr" = {
            action = "resume";
            options.desc = "[S]earch [R]esume";
          };
          "<leader>s." = {
            action = "oldfiles";
            options.desc = "[S]earch Recent Files (\".\" for repeat)";
          };
          "<leader><leader>" = {
            action = "buffers";
            options.desc = "[ ] Find existing buffers";
          };
        };
      };

      # TODO Luvid meta?
      fidget.enable = true;
      lsp = {
        enable = true;
        # TODO Do we have to modify the capabilities table using lsp.capabilities?
        servers.lua-ls = {
          enable = true;
          settings.completion.callSnippet = "Replace";
        };
        # TODO What does buffer = event.buf do?
        keymaps = {
          diagnostic."<leader>q" = {
            action = "setloclist";
            desc = "Open diagnostic [Q]uickfix list";
          };
          lspBuf = {
            "<leader>rn" = {
              action = "rename";
              desc = "LSP: [R]e[n]ame";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "LSP: [C]ode [A]ction";
            };
            gD = {
              action = "declaration";
              desc = "LSP: [G]oto [D]eclaration";
            };
          };
          extra = [
            {
              mode = "n";
              key = "gd";
              action = mkRaw "require('telescope.builtin').lsp_definitions";
              options.desc = "LSP: [G]oto [D]efinition";
            }
            {
              mode = "n";
              key = "gr";
              action = mkRaw "require('telescope.builtin').lsp_references";
              options.desc = "LSP: [G]oto [R]eferences";
            }
            {
              mode = "n";
              key = "gI";
              action = mkRaw "require('telescope.builtin').lsp_implementations";
              options.desc = "LSP: [G]oto [I]mplementation";
            }
            {
              mode = "n";
              key = "<leader>D";
              action = mkRaw "require('telescope.builtin').lsp_type_definitions";
              options.desc = "LSP: Type [D]efinition";
            }
            {
              mode = "n";
              key = "<leader>ds";
              action = mkRaw "require('telescope.builtin').lsp_document_symbols";
              options.desc = "LSP: [D]ocument [S]ymbols";
            }
            {
              mode = "n";
              key = "<leader>ws";
              action = mkRaw "require('telescope.builtin').lsp_dynamic_workspace_symbols";
              options.desc = "LSP: [W]orkspace [S]ymbols";
            }
          ];
        };

        onAttach = ''
          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        '';
      };

      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = false;
          formatters_by_ft.lua = ["stylua"];
          format_on_save = ''
            function(bufnr)
              local disable_filetypes = { c = true, cpp = true }
              return {
                timeout_ms = 500,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
              }
            end
          '';
        };
      };

      luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          completion.completeopt = "menu,menuone,noinsert";
          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-y>" = "cmp.mapping.confirm { select = true }";
            "<C-Space>" = "cmp.mapping.complete {}";
            "<C-l>" = ''
              cmp.mapping(function()
                if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                end
              end, { 'i', 's' })
            '';
            "<C-h>" = ''
              cmp.mapping(function()
                if luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                end
              end, { 'i', 's' })
            '';
          };
          # TODO autoEnableSources is enabled by default, remove unnecessary plugins
          sources = [
            {
              name = "lazydev";
              group_index = 0;
            }
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "path";}
          ];
        };
      };

      todo-comments = {
        enable = true;
        settings.signs = false;
      };

      mini = {
        enable = true;
        modules = {
          ai.n_lines = 500;
          surround = {};
          statusline.use_icons = true;
        };
      };

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          # TODO additional_vim_regex_highlighting
          indent.enable = true;
        };
      };
    };
  };
}
