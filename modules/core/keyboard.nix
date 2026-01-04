{
  lib,
  pkgs,
  config,
  ...
}: {
  options.core.keyboard.enable = lib.mkEnableOption "the Graphite keyboard layout with home row mods";

  config = lib.mkIf config.core.keyboard.enable {
    os.services.keyd.enable = true;

    os.services.keyd.keyboards.default = {
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

          a = "overload(alt, n)";
          s = "overload(meta, r)";
          d = "overload(control, t)";
          f = "overload(shift, s)";
          h = "y";
          j = "overload(shift, h)";
          k = "overload(control, a)";
          l = "overload(meta, e)";
          ";" = "overload(alt, i)";

          z = "q";
          c = "m";
          v = "c";
          b = "v";
          n = "k";
          m = "p";
          "/" = "_";

          capslock = "esc";
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

          a = "overload(alt, 1)";
          s = "overload(meta, 2)";
          d = "overload(control, 3)";
          f = "overload(symbolsshift, 4)";
          g = "5";
          h = "6";
          j = "overload(symbolsshift, 7)";
          k = "overload(control, 8)";
          l = "overload(meta, 9)";
          ";" = "overload(alt, 0)";

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
          u = "Ö";
          i = "ö";
          o = "ü";
          p = "Ü";
          d = "`";
          f = "ß";
          g = "~";
          k = "ä";
          l = "Ä";
        };
      };
    };

    hm.home.file.".XCompose".source = "${pkgs.keyd}/share/keyd/keyd.compose";
  };
}
