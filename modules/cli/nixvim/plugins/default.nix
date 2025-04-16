{
  pkgs,
  config,
  ...
}: {
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

  hm.programs.nixvim = {
    plugins = {
      sleuth.enable = true;
      web-devicons.enable = true;
      luasnip.enable = true;
      fidget.enable = true;
    };
    extraPlugins =
      [pkgs.vimPlugins.vim-wordmotion]
      ++ (
        if config.apps.kitty.enable
        then [pkgs.vimPlugins.vim-kitty-navigator]
        else []
      );
  };
}
