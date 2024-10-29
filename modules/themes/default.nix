{lib, ...}:
with lib; {
  imports = [./everforest.nix];

  options.theme = let
    camelCaseToLowercase = x:
      concatMapStrings (
        x:
          if isList x
          then " " + toLower (elemAt x 0)
          else x
      ) (split "([[:upper:]])" x);
  in {
    preset = mkOption {
      type = types.enum [null "everforest"];
      default = "everforest";
      description = "The theme preset to apply.";
    };

    fonts =
      genAttrs ["serif" "sansSerif" "monospace" "emoji"] (x: {
        package = mkOption {
          type = types.package;
          description = "The package providing the ${camelCaseToLowercase x} font.";
        };
        name = mkOption {
          type = types.str;
          description = "The font name within the ${camelCaseToLowercase x} font package.";
        };
      })
      // {
        size = mkOption {
          type = types.int;
          description = "The font size.";
        };
      };

    colors =
      genAttrs [
        "foreground"
        "background"

        "selectionBackground"

        "activeWindowBorder"
        "inactiveWindowBorder"
        "tabLineBackground"
        "activeTabForeground"
        "activeTabBackground"
        "inactiveTabForeground"
        "inactiveTabBackground"

        "terminal0"
        "terminal1"
        "terminal2"
        "terminal3"
        "terminal4"
        "terminal5"
        "terminal6"
        "terminal7"
        "terminal8"
        "terminal9"
        "terminal10"
        "terminal11"
        "terminal12"
        "terminal13"
        "terminal14"
        "terminal15"
      ] (x:
        mkOption {
          type = types.str;
          example = "#FFFFFF";
          description = "The ${camelCaseToLowercase x} color in hex.";
        })
      // genAttrs ["selectionForeground"] (x:
        mkOption {
          type = with types; nullOr str;
          default = null;
          example = "#FFFFFF";
          description = "The optional ${camelCaseToLowercase x} color in hex.";
        });

    terminalOpacity = mkOption {
      type = types.float;
      description = "The opacity of the terminal background.";
    };

    wallpaper = mkOption {
      type = types.package;
      description = "The wallpaper to use.";
    };

    cursor = {
      package = mkOption {
        type = types.package;
        description = "The package providing the cursor theme.";
      };
      name = mkOption {
        type = types.str;
        description = "The cursor name within the cursor theme package.";
      };
      size = mkOption {
        type = types.int;
        description = "The cursor size.";
      };
    };
  };
}
