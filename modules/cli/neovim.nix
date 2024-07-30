{
  lib,
  inputs,
  config,
  ...
}:
with lib; let
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

  config.hm.programs.nixvim.enable = mkIf cfg.enable true;
}
