{lib, ...}: {
  imports = [(lib.mkAliasOptionModule ["theme" "editor"] ["cli" "editor" "settings" "theme"]) ./everforest.nix ./stylix.nix];

  options.theme = {
    cursor = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The package providing the cursor theme.";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The cursor name within the cursor theme package.";
      };
      size = lib.mkOption {
        type = lib.types.int;
        description = "The cursor size.";
      };
    };

    fontSizes = let
      mkFontSizeOption = x:
        lib.mkOption {
          type = lib.types.int;
          description = "The font size used for ${x}.";
        };
    in {
      desktop = mkFontSizeOption "general elements of the desktop";
      applications = mkFontSizeOption "applications";
      terminal = mkFontSizeOption "the terminal and text editors";
      popups = mkFontSizeOption "overlay elements of the desktop";
    };

    fonts =
      lib.mapAttrs (_: x: {
        package = lib.mkOption {
          type = lib.types.package;
          description = "The package providing the ${x} font.";
        };
        name = lib.mkOption {
          type = lib.types.str;
          description = "The font name within the ${x} font package.";
        };
      }) {
        serif = "serif";
        sansSerif = "sans-serif";
        monospace = "monospace";
        emoji = "emoji";
      };

    colors = lib.genAttrs ["base00" "base01" "base02" "base03" "base04" "base05" "base06" "base07" "base08" "base09" "base0A" "base0B" "base0C" "base0D" "base0E" "base0F"] (x:
      lib.mkOption {
        type = lib.types.str;
        description = "The ${x} color.";
      });

    windowOpacity = lib.mkOption {
      type = lib.types.float;
      description = "The opacity of the windows.";
    };

    wallpaper = lib.mkOption {
      type = lib.types.package;
      description = "The wallpaper to use.";
    };
  };

  config.theme.everforest.enable = lib.mkDefault true;
  config.theme.stylix.enable = lib.mkDefault true;
}
