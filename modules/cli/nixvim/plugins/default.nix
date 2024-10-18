{
  imports = [./telescope.nix ./treesitter.nix ./mini.nix ./lsp.nix ./cmp.nix ./conform.nix ./gitsigns.nix];

  hm.programs.nixvim.plugins = {
    sleuth.enable = true;
    web-devicons.enable = true;
    fidget.enable = true;
  };
}
