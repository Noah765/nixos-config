{pkgs, ...}: {
  imports = [
    ./telescope.nix
    ./treesitter.nix
    ./mini.nix
    ./lsp.nix
    # TODO ./dap.nix
    ./cmp.nix
    ./conform.nix
    ./gitsigns.nix
  ];

  dependencies = ["apps.kitty"];

  hm.programs.nixvim = {
    plugins = {
      sleuth.enable = true;
      web-devicons.enable = true;
      luasnip.enable = true;
    };
    extraPlugins = [pkgs.vimPlugins.vim-kitty-navigator];
  };
}
