{
  lib,
  inputs,
  config,
  ...
}: {
  inputs.nixvim.url = "github:nix-community/nixvim";

  imports = [
    (lib.mkAliasOptionModule ["cli" "editor" "settings"] ["hm" "programs" "nixvim"])
    ./basic.nix
    ./formatting.nix
    ./himalaya.nix
    ./lsp.nix
    ./mini-ai.nix
    ./mini-files.nix
    ./mini-jump2d.nix
    ./navbuddy.nix
    ./spell-checking.nix
    ./telescope.nix
  ];
  hmImports = [inputs.nixvim.homeModules.default];

  options.cli.editor.enable = lib.mkEnableOption "Neovim";

  config = lib.mkIf config.cli.editor.enable {
    cli.editor = {
      basic.enable = lib.mkDefault true;
      formatting.enable = lib.mkDefault true;
      himalaya.enable = lib.mkDefault true;
      lsp.enable = lib.mkDefault true;
      mini-ai.enable = lib.mkDefault true;
      mini-files.enable = lib.mkDefault true;
      mini-jump2d.enable = lib.mkDefault true;
      navbuddy.enable = lib.mkDefault true;
      spell-checking.enable = lib.mkDefault true;
      telescope.enable = lib.mkDefault true;
    };

    theme.stylix.hmTargets.nixvim.enable = false;

    hm.programs.nixvim = {
      enable = true;
      defaultEditor = true;

      # TODO Move into modules
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
        illuminate.settings.min_count_to_highlight = 2;
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
              draw.animation = config.hm.lib.nixvim.utils.mkRaw "require('mini.indentscope').gen_animation.none()";
              draw.delay = 0;
              options.try_as_border = true;
              symbol = "│";
            };
            surround = {};
          };
        };
        nvim-autopairs.enable = true; # TODO Maybe use mini.pairs instead
        sleuth.enable = true;
        treesitter.enable = true;
        which-key.enable = true;
        which-key.settings = {
          preset = "helix";
          delay = 0;
          spec = lib.singleton (config.hm.lib.nixvim.utils.listToUnkeyedAttrs ["<leader>t"] // {group = "Toggle";});
          plugins.spelling.enabled = false;
        };
      };
    };
  };
}
