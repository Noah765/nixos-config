{
  lib,
  pkgs,
  config,
  ...
}: {
  options.theme.everforest.enable = lib.mkEnableOption "Everforest";

  config.theme = lib.mkIf config.theme.everforest.enable {
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fontSizes = {
      desktop = 10;
      applications = 10;
      terminal = 10;
      popups = 10;
    };

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
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    colors = {
      base00 = "#272e33";
      base01 = "#2e383c";
      base02 = "#414b50";
      base03 = "#859289";
      base04 = "#9da9a0";
      base05 = "#d3c6aa";
      base06 = "#edeada";
      base07 = "#fffbef";
      base08 = "#e67e80";
      base09 = "#e69875";
      base0A = "#dbbc7f";
      base0B = "#a7c080";
      base0C = "#83c092";
      base0D = "#7fbbb3";
      base0E = "#d699b6";
      base0F = "#9da9a0";
    };

    windowOpacity = 0.75;

    wallpaper = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/refs/heads/main/nature/mist_forest_2.png";
      hash = "sha256-OESOGuDqq1BI+ESqzzMVu58xQafwxT905gSvCjMCfS0=";
    };
  };
}
