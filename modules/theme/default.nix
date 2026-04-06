{lib, ...}: {
  nixos = {config, ...}: {
    imports = [
      (lib.mkAliasOptionModule ["theme" "base16"] ["stylix" "base16Scheme"])
      (lib.mkAliasOptionModule ["theme" "editor"] ["cli" "editor" "settings" "theme"])
      (lib.mkAliasOptionModule ["theme" "fileManager"] ["cli" "fileManager" "theme"])
    ];

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

      colors = lib.mkOption {internal = true;};

      windowOpacity = lib.mkOption {
        type = lib.types.float;
        description = "The opacity of the windows.";
      };

      wallpaper = {
        background = lib.mkOption {
          type = lib.types.pathInStore;
          description = "The wallpaper background to use.";
        };
        middleGround = lib.mkOption {
          type = lib.types.pathInStore;
          description = "The wallpaper middle ground to use.";
        };
        foreground = lib.mkOption {
          type = lib.types.pathInStore;
          description = "The wallpaper foreground to use.";
        };
      };
    };

    config.theme = {
      inherit (config.lib.stylix) colors;
      everforest.enable = lib.mkDefault true;
      stylix.enable = lib.mkDefault true;
    };
  };
}
