{
  lib,
  inputs,
  config,
  ...
}:
with lib; let
  cfg = config.cli.nixvim;
in {
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [./options.nix ./globals.nix ./autocommands.nix ./keymaps.nix ./plugins];

  hmImports = [inputs.nixvim.homeManagerModules.default];

  options.cli.nixvim.enable = mkEnableOption "NixVim";

  config = {
    dependencies = ["cli.ripgrep"];

    hm.stylix.targets.nixvim.enable = false;

    hm.programs.nixvim = mkIf cfg.enable {
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

      performance = {
        byteCompileLua = {
          enable = true;
          configs = true;
          initLua = true;
          nvimRuntime = true;
          plugins = true;
        };
        combinePlugins = {
          enable = true;
          standalonePlugins = ["nvim-treesitter"];
        };
      };
    };
  };
}
