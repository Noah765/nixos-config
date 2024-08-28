{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.core.keyboard;
in {
  options.core.keyboard.enable = mkEnableOption "the Graphite keyboard layout with home row mods";

  config.os.services.keyd = mkIf cfg.enable {
    enable = true;

    keyboards.default = {
      ids = ["*"];

      settings = {
        main = {
          q = "b";
          w = "l";
          e = "d";
          r = "w";
          t = "z";
          y = "'";
          u = "f";
          i = "o";
          o = "u";
          p = "j";

          a = "overloadt2(alt, n, 500)";
          s = "overloadt2(meta, r, 500)";
          d = "overloadt2(shift, t, 500)";
          f = "overloadt2(control, s, 500)";
          h = "y";
          j = "overloadt2(control, h, 500)";
          k = "overloadt2(shift, a, 500)";
          l = "overloadt2(meta, e, 500)";
          ";" = "overloadt2(alt, i, 500)";

          z = "q";
          c = "m";
          v = "c";
          b = "v";
          n = "k";
          m = "p";
          "/" = "_";

          rightalt = "layer(symbols)";
        };

        shift = {
          "," = "(";
          "." = ")";
          "/" = "=";
        };

        symbols = {
          q = "#";
          w = "^";
          e = ":";
          r = "{";
          t = "[";
          y = "]";
          u = "}";
          i = ";";
          o = "$";
          p = "|";

          a = "overloadt2(alt, 1, 500)";
          s = "overloadt2(meta, 2, 500)";
          d = "overloadt2(symbolsshift, 3, 500)";
          f = "overloadt2(control, 4, 500)";
          g = "5";
          h = "6";
          j = "overloadt2(control, 7, 500)";
          k = "overloadt2(symbolsshift, 8, 500)";
          l = "overloadt2(meta, 9, 500)";
          ";" = "overloadt2(alt, 0, 500)";

          z = "?";
          x = "*";
          c = "/";
          v = "%";
          b = "<";
          n = ">";
          m = "\\";
          "," = "+";
          "." = "-";
          "/" = "&";
        };

        "symbolsshift:S" = {
          d = "`";
          f = "~";
        };
      };
    };
  };
}
