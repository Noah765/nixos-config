{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  # TODO Check if the mkDefault works as expected
  config.theme = mkIf (config.theme.preset == "everforest") (mkDefault {
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
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      size = 10;
    };

    colors = let
      bgDim = "#1E2326";
      bg0 = "#272E33";
      bg1 = "#2E383C";
      bg2 = "#374145";
      bg3 = "#414B50";
      bg4 = "#495156";
      bg5 = "#4F5B58";
      bgVisual = "#4C3743";
      bgRed = "#493B40";
      bgGreen = "#3C4841";
      bgBlue = "#384B55";
      bgYellow = "#45443C";
      fg = "#D3C6AA";
      red = "#E67E80";
      orange = "#E69875";
      yellow = "#DBBC7F";
      green = "#A7C080";
      aqua = "#83C092";
      blue = "#7FBBB3";
      purple = "#D699B6";
      grey0 = "#7A8478";
      grey1 = "#859289";
      grey2 = "#9DA9A0";
      statusline1 = green;
      statusline2 = fg;
      statusline3 = red;
    in {
      foreground = fg;
      background = bg0;

      selectionBackground = bgVisual;

      activeWindowBorder = green;
      inactiveWindowBorder = bg4;
      tabLineBackground = bg1;
      activeTabForeground = bg0;
      activeTabBackground = statusline1;
      inactiveTabForeground = grey2;
      inactiveTabBackground = bg3;

      terminal0 = bg3;
      terminal1 = red;
      terminal2 = green;
      terminal3 = yellow;
      terminal4 = blue;
      terminal5 = purple;
      terminal6 = aqua;
      terminal7 = fg;
      terminal8 = bg3;
      terminal9 = red;
      terminal10 = green;
      terminal11 = yellow;
      terminal12 = blue;
      terminal13 = purple;
      terminal14 = aqua;
      terminal15 = fg;
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
