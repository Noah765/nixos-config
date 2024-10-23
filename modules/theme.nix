{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.theme;
in {
  options.theme = let
    mkPackageOption = description:
      mkOption {
        type = types.package;
        inherit description;
      };
    mkStringOption = description:
      mkOption {
        type = types.str;
        inherit description;
      };
    mkColorOption = name:
      mkOption {
        type = types.str;
        example = "#AAAAAA";
        description = "The ${name} color in hex.";
      };
    mkOptionalColorOption = name:
      mkOption {
        type = with types; nullOr str;
        default = null;
        example = "#AAAAAA";
        description = "The optional ${name} color in hex.";
      };
  in {
    preset = mkOption {
      type = types.enum [null "everforest"];
      default = "everforest";
      description = "The theme to use.";
    };
    fonts = {
      serif = {
        package = mkPackageOption "The package providing the serif font.";
        name = mkStringOption "The font name within the package.";
      };
      sansSerif = {
        package = mkPackageOption "The package providing the Sans-serif font.";
        name = mkStringOption "The font name within the package.";
      };
      monospace = {
        package = mkPackageOption "The package providing the monospace font.";
        name = mkStringOption "The font name within the package.";
      };
      emoji = {
        package = mkPackageOption "The package providing the emoji font.";
        name = mkStringOption "The font name within the package.";
      };
    };
    colors = {
      foreground = mkColorOption "default foreground";
      selectionForeground = mkOptionalColorOption "selection foreground";
      background = mkColorOption "default background";
      selectionBackground = mkColorOption "selection background";
      accent = mkColorOption "main accent";
      warning = mkColorOption "warning";
      error = mkColorOption "error";

      black = mkColorOption "black";
      red = mkColorOption "red";
      green = mkColorOption "green";
      yellow = mkColorOption "yellow";
      blue = mkColorOption "blue";
      magenta = mkColorOption "magenta";
      cyan = mkColorOption "cyan";
      white = mkColorOption "white";
    };
    terminalOpacity = mkOption {
      type = types.float;
      description = "The opacity of the terminal background.";
    };
    wallpaper = mkPackageOption "The wallpaper to use.";
    cursor = {
      package = mkPackageOption "The package providing the cursor theme.";
      name = mkStringOption "The cursor name within the package.";
      size = mkOption {
        type = types.int;
        description = "The cursor size.";
      };
    };
  };

  # TODO Check if the mkDefault works as expected
  config.theme = mkIf (cfg.preset == "everforest") (mkDefault {
    # TODO Explore alternative fonts
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    colors = {
      foreground = "#D3C6AA";
      background = "#272E33";
      selectionBackground = "#4C3743";
      accent = "#A7C080";
      warning = "#DBBC7F"; # TODO Are warning and error colors used?
      error = "#E67E80";

      black = "#272E33"; # TODO Maybe change to bg3 like everforest does? Only if it looks better.
      red = "#E67E80";
      green = "#A7C080";
      yellow = "#DBBC7F";
      blue = "#7FBBB3";
      magenta = "#D699B6";
      cyan = "#83C092";
      white = "#D3C6AA";
    };
    terminalOpacity = 0.75;
    wallpaper = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/refs/heads/main/nature/mist_forest_2.png";
      hash = "sha256-OESOGuDqq1BI+ESqzzMVu58xQafwxT905gSvCjMCfS0=";
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  });
}
