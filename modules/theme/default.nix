{lib, ...}: let
  inherit (lib) concatMapStrings elemAt genAttrs isList mkOption split toLower;
  inherit (lib.types) enum float int nullOr package str;
in {
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
      type = enum [null "everforest"];
      default = "everforest";
      description = "The theme preset to apply.";
    };

    fonts =
      genAttrs ["serif" "sansSerif" "monospace" "emoji"] (x: {
        package = mkOption {
          type = package;
          description = "The package providing the ${camelCaseToLowercase x} font.";
        };
        name = mkOption {
          type = str;
          description = "The font name within the ${camelCaseToLowercase x} font package.";
        };
      })
      // {
        size = mkOption {
          type = int;
          description = "The font size.";
        };
      };

    colors =
      genAttrs [
        "foreground"
        "background"

        "activeWindowBorder"
        "inactiveWindowBorder"
        "tabLineBackground"
        "activeTabForeground"
        "activeTabBackground"
        "inactiveTabForeground"
        "inactiveTabBackground"

        "border"
        "url"
        "activeForeground"
        "activeBackground"
        "selectionBackground"

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
          type = str;
          example = "#FFFFFF";
          description = "The ${camelCaseToLowercase x} color in hex.";
        })
      // genAttrs ["selectionForeground"] (x:
        mkOption {
          type = nullOr str;
          default = null;
          example = "#FFFFFF";
          description = "The optional ${camelCaseToLowercase x} color in hex.";
        });

    terminalOpacity = mkOption {
      type = float;
      description = "The opacity of the terminal background.";
    };

    wallpaper = mkOption {
      type = package;
      description = "The wallpaper to use.";
    };

    cursor = {
      package = mkOption {
        type = package;
        description = "The package providing the cursor theme.";
      };
      name = mkOption {
        type = str;
        description = "The cursor name within the cursor theme package.";
      };
      size = mkOption {
        type = int;
        description = "The cursor size.";
      };
    };
  };
}
