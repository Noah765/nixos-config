{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./cmp.nix
    ./conform.nix
    # TODO ./dap.nix
    ./gitsigns.nix
    ./lsp.nix
    ./mini.nix
    ./telescope.nix
    ./treesitter.nix
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
