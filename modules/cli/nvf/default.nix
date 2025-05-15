{
  lib,
  inputs,
  pkgs,
  configName,
  config,
  ...
}: {
  inputs.nvf = {
    url = "github:NotAShelf/nvf";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    (lib.doRename {
      from = ["cli" "nvf" "settings"];
      to = ["hm" "programs" "nvf" "settings" "vim"];
      visible = true;
      warn = false;
      use = lib.id;
      withPriority = false;
    })
    ./fastaction.nix
    ./illuminate.nix
    ./mini-ai.nix
    ./mini-files.nix
    ./mini-indentscope.nix
    ./mini-jump.nix
    ./mini-jump2d.nix
    ./navbuddy.nix
    ./noice.nix
  ];
  hmImports = [inputs.nvf.homeManagerModules.default];

  options.cli.nvf.enable = lib.mkEnableOption "nvf";

  config = lib.mkIf config.cli.nvf.enable {
    cli.nvf = {
      fastaction.enable = lib.mkDefault true;
      illuminate.enable = lib.mkDefault true;
      mini-ai.enable = lib.mkDefault true;
      mini-files.enable = lib.mkDefault true;
      mini-indentscope.enable = lib.mkDefault true;
      mini-jump.enable = lib.mkDefault true;
      mini-jump2d.enable = lib.mkDefault true;
      navbuddy.enable = lib.mkDefault true;
      noice.enable = lib.mkDefault true;
    };

    hm.programs.nvf = {
      enable = true;
      defaultEditor = true;

      # TODO window borders (https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/basics.lua#L541-L547 helpful?)
      # TODO movement by visible lines (wrapping) https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/basics.lua#L556-L561
      settings.vim = {
        # enableLuaLoader = true;
        # TODO assistant
        autocomplete.blink-cmp = {
          # TODO keep fuzzy db at .local/share/nvf/blink/cmp/fuzzy.db?
          enable = true; # TODO configure
          # TODO friendly-snippets.enable
          # TODO https://cmp.saghen.dev/configuration/general.html
          # TODO sourcePlugins
          setupOpts = {
            keymap = {
              preset = "default";
              "<C-l>" = ["snippet_forward" "fallback"];
              "<C-h>" = ["snippet_backward" "fallback"];
            };
            signature = {
              enabled = true;
              trigger.show_on_insert = true;
            };
          };
        };
        autopairs.nvim-autopairs.enable = true; # TODO Configure, maybe use mini.pairs instead
        binds = {
          # TODO cheatsheet.enable maybe for emojis?
          # TODO which-key.extras
          whichKey = {
            enable = true;
            # TODO configure, e.g. register
            setupOpts = {
              preset = "helix";
              delay = 0;
            };
          };
        };
        # TODO comment.nvim
        # TODO dashboard
        # TODO debugMode for debugging this config
        debugger.nvim-dap = {
          enable = true;
          # TODO configure, test
        };
        # TODO diagnostics.enable; diagnostics.config; probably no need to set this manually
        # TODO diagnostics.nvim-lint settings (used by languages extra diagnostics)
        extraPlugins.kitty-navigator.package = pkgs.vimPlugins.vim-kitty-navigator;
        # TODO is conform-nvim needed or is lsp formatting enough? auto installed
        git.enable = true; # TODO configure, also look at mini.diff and mini.git
        # TODO globals
        highlight.MiniJump2dSpotAhead.fg = "grey"; # TODO move to theme, or everforest PR, or remove when possible; maybe link to MiniJump2dSpot?
        languages = {
          # TODO Spread across dev modules
          enableDAP = true;
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableTreesitter = true;

          # TODO move to dev modules
          dart = {
            enable = true;
            flutter-tools.color = {
              enable = true;
              virtualText.enable = true;
            };
          };
          nix = {
            enable = true;
            lsp = {
              server = "nixd";
              options.modulix.expr = "(builtins.getFlake \"/etc/nixos\").modulixConfigurations.${configName}.options";
            };
          };
          nu.enable = true;
          rust.enable = true;
        };
        lsp = {
          enable = true;
          formatOnSave = true;
          # TODO enable inlay hints for specific languages
          # TODO is lspSignature better than blink's signature feature?
          # TOOD lspkind, lspsaga
          # TODO mappings
          # TODO null-ls
          otter-nvim.enable = true; # TODO configure
          # TODO trouble.nvim for showing diagnostics, etc.?
        };
        mini = {
          align.enable = true;
          # TODO look through basics after https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-basics.txt#L229
          # TODO bracketed, bufremove, comment, cursorword
          # TODO fuzzy for telescope completion?
          # TODO hipatterns for TODOs, color highlighting
          icons.enable = true; # TODO compare to nvim-web-devicons, use mock_nvim_web_devicons?
          # TODO MiniMisc.setup_restore_cursor, MiniMisc.use_nested_comments, MiniMisc.zoom?
          move.enable = true;
          # notify.enable = true; # TODO compare to fidget.nvim and nvim-notify
          operators.enable = true; # TODO whichkey completion
          # TODO pick
          # TODO sessions for session managment
          # TODO snippets instead of luasnip?
          # TODO is splitjoin ever useful?
          # TODO starter
          # TODO statusline
          surround.enable = true; # TODO config, whichkey
          # TODO tabline
          # TODO trailspace probably not useful because of formatting, showing trailing whitespace otherwise
          # TODO visits
        };
        # TODO minimap for quickly locating diagnostics? also look at mini.map then
        # TODO navigation.harpoon
        # TODO notes, notes.todo-comments
        # TODO compare nvim-notify to mini.notify
        options = {
          # TODO updatetime timeoutlen wrap matchpairs completeopt infercase smartindent? virtualedit? pumblend pumbheight winblend
          breakindent = true;
          clipboard = "unnamedplus";
          confirm = true;
          ignorecase = true;
          inccommand = "split";
          list = true;
          listchars = "tab:» ,multispace:·,lead: ,trail:·,nbsp:␣"; # TODO extends, precedes
          scrolloff = 9;
          shiftwidth = 2;
          smartcase = true;
        };
        # TODO neocord
        # TODO preventJunkFiles
        # TODO project-nvim
        # TODO run-nvim
        # TODO nvim-session-manager
        # TODO luasnip
        spellcheck.enable = true; # TODO extraSpellWords, ignoredFiletypes, languages
        # spellcheck.programmingWordlist.enable = true; # TODO fix if useful
        # TODO statusline
        # TODO what does syntaxHighlighting do exactly?
        # TODO tabline
        telescope.enable = true; # TODO mappings, config
        # TODO terminal
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
          transparent = true;
        };
        # TODO treesitter
        # TODO ui.borders
        # TODO ui.colorizer or https://github.com/neovim/neovim/pull/33440
        # TODO look at remaining options starting from ui
        utility.sleuth.enable = true;
      };
    };
  };
}
