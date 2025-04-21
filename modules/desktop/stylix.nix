{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  inputs.stylix = {
    url = "github:danth/stylix";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
    };
  };

  osImports = [inputs.stylix.nixosModules.stylix];

  options.desktop.stylix.enable = lib.mkEnableOption "Stylix";

  config.os = {
    # TODO Remove the overlay once nixpkgs includes the commit
    nixpkgs.overlays = [
      (final: prev: {
        base16-schemes = prev.base16-schemes.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "tinted-theming";
            repo = "schemes";
            rev = "43ba59b50b9cd49ddc67f9aab82826f9007ee4e6";
            hash = "sha256-7TgpQx6JP3t/aSJW+yv5gEXceCIw8qTnhCAT3LtfmeY=";
          };
        });
      })
    ];

    # TODO Delete or fix the enable option
    stylix = {
      enable = config.desktop.stylix.enable;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";

      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/refs/heads/main/nature/mist_forest_2.png";
        hash = "sha256-OESOGuDqq1BI+ESqzzMVu58xQafwxT905gSvCjMCfS0=";
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        sizes = {
          terminal = 10;
          applications = 10;
        };
      };

      opacity.terminal = 0.75;
    };
  };
}
