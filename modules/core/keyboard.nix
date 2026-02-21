{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.core.keyboard.enable = lib.mkEnableOption "the Graphite keyboard layout with home row mods";

    config = lib.mkIf config.core.keyboard.enable {
      services.keyd.enable = true;

      services.keyd.keyboards.default = {
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

            a = "overloadt(alt, n, 150)";
            s = "overloadt(meta, r, 150)";
            d = "overloadt(control, t, 150)";
            f = "overloadt(shift, s, 150)";
            h = "y";
            j = "overloadt(shift, h, 150)";
            k = "overloadt(control, a, 150)";
            l = "overloadt(meta, e, 150)";
            ";" = "overloadt(alt, i, 150)";

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

            a = "overloadt(alt, 1, 150)";
            s = "overloadt(meta, 2, 150)";
            d = "overloadt(control, 3, 150)";
            f = "overloadt(symbolsshift, 4, 150)";
            g = "5";
            h = "6";
            j = "overloadt(symbolsshift, 7, 150)";
            k = "overloadt(control, 8, 150)";
            l = "overloadt(meta, 9, 150)";
            ";" = "overloadt(alt, 0, 150)";

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
  };
}
