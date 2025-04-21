{
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    ./autocommands.nix
    ./globals.nix
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];

  hmImports = [inputs.nixvim.homeManagerModules.default];

  options.cli.nixvim.enable = mkEnableOption "NixVim";

  config = {
    dependencies = ["cli.ripgrep"];

    hm.stylix.targets.nixvim.enable = false;

    hm.programs.nixvim = mkIf config.cli.nixvim.enable {
      enable = true;
      defaultEditor = true;
      nixpkgs.useGlobalPackages = true;

      colorschemes.everforest = {
        enable = true;
        settings = {
          transparent_background = 1;
          background = "hard";
        };
      };
    };
  };
}
