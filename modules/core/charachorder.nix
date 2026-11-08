{lib, ...}: {
  nixos = {config, ...}: {
    options.core.charachorder.enable = lib.mkEnableOption "Charachorder support";

    # The firmware stops sending input after a USB resume, so reset the device instead.
    config.boot.kernelParams = lib.mkIf config.core.charachorder.enable ["usbcore.quirks=303a:8253:b"];
  };

  perSystem = {pkgs, ...}: {
    # Ghostty encodes numpad keys, and the kitty keyboard protocol modified system keys, by their
    # physical key, so Scroll Lock, Pause and Num Lock only hold one-level symbols. XKB rules always
    # add inet(evdev), which overrides most other keys.
    packages.charachorder-keymap = let
      symbols = pkgs.writeTextDir "symbols/cc" ''
        xkb_symbols "cc"
        {
          include "us(basic)"

          key.type = "ONE_LEVEL";
          key <SCLK> { [ parenleft    ] };
          key <AB10> { [ slash        ] };
          key <LSGT> { type = "ALPHABETIC", [ udiaeresis, Udiaeresis ] };
          key <AE12> { [ equal        ] };
          key <PAUS> { [ parenright   ] };
          key <AC11> { [ apostrophe   ] };
          key <OPEN> { type = "ALPHABETIC", [ odiaeresis, Odiaeresis ] };
          key <NMLK> { [ underscore   ] };
          key <PROP> { type = "ALPHABETIC", [ adiaeresis, Adiaeresis ] };
          key <AB09> { [ period       ] };
          key <AB08> { [ comma        ] };
          key <FRNT> { type = "ALPHABETIC", [ ssharp, U1E9E ] };
          key <AC10> { [ semicolon    ] };
          key <STOP> { [ plus         ] };
          key <AGAI> { [ degree       ] };
          key <AE09> { [ 9            ] };
          key <UNDO> { [ asciicircum  ] };
          key <CUT>  { [ numbersign   ] };
          key <FIND> { [ percent      ] };
          key <AE07> { [ 7            ] };
          key <AD11> { [ bracketleft  ] };
          key <I129> { [ greater      ] };
          key <AE05> { [ 5            ] };
          key <AB11> { [ quotedbl     ] };
          key <HKTG> { [ braceleft    ] };
          key <AE13> { [ colon        ] };
          key <AE01> { [ 1            ] };
          key <HENK> { [ ampersand    ] };
          key <BKSL> { [ backslash    ] };
          key <AE03> { [ 3            ] };
          key <TLDE> { [ grave        ] };
          key <MUHE> { [ at           ] };
          key <AE02> { [ 2            ] };
          key <JPCM> { [ question     ] };
          key <I248> { [ braceright   ] };
          key <AE10> { [ 0            ] };
          key <HNGL> { [ asterisk     ] };
          key <HJCV> { [ less         ] };
          key <AE04> { [ 4            ] };
          key <AE11> { [ minus        ] };
          key <KATA> { [ dollar       ] };
          key <AE06> { [ 6            ] };
          key <HIRA> { [ exclam       ] };
          key <AD12> { [ bracketright ] };
          key <ZEHA> { [ bar          ] };
          key <AE08> { [ 8            ] };
          key <I187> { [ EuroSign     ] };
          key <I188> { [ asciitilde   ] };
        };
      '';
      keymap = pkgs.writeText "cc.xkb" ''
        xkb_keymap {
          xkb_keycodes { include "evdev+aliases(qwerty)" };
          xkb_types { include "complete" };
          xkb_compat { include "complete" };
          xkb_symbols { include "pc+cc" };
        };
      '';
    in
      pkgs.runCommand "charachorder-keymap" {} ''
        ${lib.getExe' pkgs.libxkbcommon "xkbcli"} compile-keymap --include ${symbols} --include-defaults --from-xkb ${keymap} > $out
      '';
  };
}
