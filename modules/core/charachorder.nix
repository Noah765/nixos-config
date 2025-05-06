{
  lib,
  pkgs,
  config,
  ...
}: {
  options.core.charachorder.enable = lib.mkEnableOption "a keyboard layout for the Charachorder";

  config = lib.mkIf config.core.charachorder.enable {
    desktop.hyprland.settings.input.kb_layout = "cc";

    os.services.xserver.xkb.extraLayouts.cc = {
      description = "CC layout";
      languages = ["eng"];
      symbolsFile = pkgs.writeText "cc" ''
        xkb_symbols "cc"
        {
          include "us(basic)"

          key.type = "ONE_LEVEL";
          key <PRSC> { [ parenleft    ] };
          key <AB10> { [ slash        ] };
          key <SCLK> { type = "ALPHABETIC", [ udiaeresis, Udiaeresis ] };
          key <AE12> { [ equal        ] };
          key <PAUS> { [ parenright   ] };
          key <AC11> { [ apostrophe   ] };
          key <INS>  { type = "ALPHABETIC", [ odiaeresis, Odiaeresis ] };
          key <NMLK> { [ underscore   ] };
          key <KPDV> { type = "ALPHABETIC", [ adiaeresis, Adiaeresis ] };
          key <AB09> { [ period       ] };
          key <AB08> { [ comma        ] };
          key <KPMU> { type = "ALPHABETIC", [ ssharp, U1E9E ] };
          key <AC10> { [ semicolon    ] };
          key <KPSU> { [ plus         ] };
          key <KPAD> { [ degree       ] };
          key <AE09> { [ 9            ] };
          key <KPEN> { [ asciicircum  ] };
          key <KP1>  { [ numbersign   ] };
          key <KP2>  { [ percent      ] };
          key <AE07> { [ 7            ] };
          key <AD11> { [ bracketleft  ] };
          key <KP3>  { [ greater      ] };
          key <AE05> { [ 5            ] };
          key <KP4>  { [ quotedbl     ] };
          key <KP5>  { [ braceleft    ] };
          key <KP6>  { [ colon        ] };
          key <AE01> { [ 1            ] };
          key <KP7>  { [ ampersand    ] };
          key <BKSL> { [ backslash    ] };
          key <AE03> { [ 3            ] };
          key <TLDE> { [ grave        ] };
          key <KP8>  { [ at           ] };
          key <AE02> { [ 2            ] };
          key <KP9>  { [ question     ] };
          key <KP0>  { [ braceright   ] };
          key <AE10> { [ 0            ] };
          key <KPDL> { [ asterisk     ] };
          key <LSGT> { [ less         ] };
          key <AE04> { [ 4            ] };
          key <AE11> { [ minus        ] };
          key <COMP> { [ dollar       ] };
          key <AE06> { [ 6            ] };
          key <KPEQ> { [ exclam       ] };
          key <AD12> { [ bracketright ] };
          key <FK19> { [ bar          ] };
          key <AE08> { [ 8            ] };
          key <FK24> { [ EuroSign     ] };
          key <I248> { [ asciitilde   ] };
        };
      '';
    };
  };
}
