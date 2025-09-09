{lib, ...}: let
  inherit (lib.nixvim.utils) mkRaw;
in {
  imports = [./formatting.nix ./mini-ai.nix ./mini-files.nix ./mini-jump2d.nix ./navbuddy.nix ./spell-checking.nix];

  autoCmd = lib.singleton {
    event = "TextYankPost";
    callback = mkRaw ''function() vim.hl.on_yank() end'';
  };
  clipboard.providers.wl-copy.enable = true; # TODO
  clipboard.register = "unnamedplus";
  colorschemes.everforest.enable = true;
  colorschemes.everforest.settings = {
    background = "hard";
    enable_italic = 1;
  };
  dependencies.ripgrep.enable = true;
  globals.mapleader = " ";
  globals.maplocalleader = " ";
  keymaps = lib.singleton {
    key = "<Esc>";
    mode = "n";
    action = "<cmd>nohlsearch<CR>";
    options.desc = "Clear search highlights";
  };
  lsp.servers = {
    dartls.enable = true;
    nixd.enable = true;
    nixd.settings.settings.nixd.options.modulix.expr = "(builtins.getFlake \"/etc/nixos\").modulixConfigurations.primary.options";
    rust_analyzer.enable = true;
  };
  opts = {
    breakindent = true;
    confirm = true;
    ignorecase = true;
    inccommand = "split";
    list = true;
    listchars = "tab:» ,multispace:·,lead: ,trail:·,nbsp:␣"; # TODO extends, precedes
    number = true;
    relativenumber = true;
    scrolloff = 9;
    shiftwidth = 2;
    signcolumn = "yes";
    smartcase = true;
    splitbelow = true;
    splitright = true;
  };
  plugins = {
    blink-cmp.enable = true;
    blink-cmp.settings = {
      keymap = {
        preset = "default";
        "<C-l>" = ["snippet_forward" "fallback"];
        "<C-h>" = ["snippet_backward" "fallback"];
      };
      signature.enabled = true;
      signature.trigger.show_on_insert = true;
    };
    fidget.enable = true;
    gitsigns.enable = true;
    illuminate.enable = true;
    illuminate.minCountToHighlight = 2;
    lspconfig.enable = true;
    mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        align = {};
        icons = {};
        jump.delay.highlight = 0;
        move = {};
        operators = {};
        indentscope = {
          draw.animation = mkRaw "require('mini.indentscope').gen_animation.none()";
          draw.delay = 0;
          options.try_as_border = true;
          symbol = "│";
        };
        surround = {};
      };
    };
    nvim-autopairs.enable = true; # TODO Maybe use mini.pairs instead
    sleuth.enable = true;
    telescope.enable = true;
    telescope.keymaps = {
      "<leader>pf" = {
        action = "find_files";
        options.desc = "Telescope find files";
      };
      "<leader>pg" = {
        action = "live_grep";
        options.desc = "Telescope grep";
      };
      "<leader>ph" = {
        action = "help_tags";
        options.desc = "Telescope help tags";
      };
      "<leader>pr" = {
        action = "resume";
        options.desc = "Telescope resume";
      };
    };
    treesitter.enable = true;
    which-key.enable = true;
    which-key.settings = {
      delay = 0;
      preset = "helix";
    };
  };
}
