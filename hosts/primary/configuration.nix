{
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  # TODO Disable global flake registry?

  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    nvidia.enable = true;
    networkmanager.hostName = "primary";
    keyboard.enable = false;
  };

  cli.installer.enable = true;

  desktop = {
    sddm.autoLogin = true;
    hyprland.settings.monitor = [
      "DP-1, 1920x1080@144, 0x0, 1"
      "HDMI-A-1, 1920x1080@75, 1920x0, 1"
    ];
  };

  dev.flutter.enable = true;

  apps.slack.enable = true;

  hm.home.packages = with pkgs; [
    cargo
    rustc

    protonup

    prismlauncher

    discord

    (pkgs.writeShellScriptBin "rb" "${getExe inputs.modulix.packages.${pkgs.system}.mxg} && ${getExe pkgs.nh} os $*")
  ];

  os.programs = {
    steam.enable = true;
    steam.gamescopeSession.enable = true;
    gamemode.enable = true;
  };
  hm.home.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  core.impermanence.hm.directories = [
    {
      directory = ".local/share/Steam";
      method = "symlink";
    }
    ".local/share/godot/app_userdata/Turing Complete"
    ".local/share/PrismLauncher"
    ".config/discord"
  ];

  core.user.groups = ["dialout"];

  desktop.hyprland.settings.bind = ["Super, M, exec, prismlauncher" "Super, D, exec, discord"];

  os.console.enable = false; # TODO

  desktop.hyprland.settings.input.kb_layout = "cc";
  os.services.xserver.xkb.extraLayouts.cc = {
    description = "CC layout";
    languages = ["eng"];
    symbolsFile = pkgs.writeText "cc" ''
      xkb_symbols "cc"
      {
        include "us(basic)"

        key.type = "ONE_LEVEL";
        key <AE01> {[1]};
        key <AE02> {[2]};
        key <AE03> {[3]};
        key <AE04> {[4]};
        key <AE05> {[5]};
        key <AE06> {[6]};
        key <AE07> {[7]};
        key <AE08> {[8]};
        key <AE09> {[9]};
        key <AE10> {[0]};
        key <AE11> {[minus]};
        key <AE12> {[equal]};
        key <TAB> {[Tab]};
        key <AD11> {[bracketleft]};
        key <AD12> {[bracketright]};
        key <AC10> {[semicolon]};
        key <AC11> {[apostrophe]};
        key <TLDE> {[grave]};
        key <BKSL> {[backslash]};
        key <AB08> {[comma]};
        key <AB09> {[period]};
        key <AB10> {[slash]};
        key <KPMU> {[parenleft]};
        key <NMLK> {[parenright]};
        key <SCLK> {[underscore]};
        key <KP7> {[plus]};
        key <KP8> {[degree]};
        key <KP9> {[asciicircum]};
        key <KPSU> {[numbersign]};
        key <KP4> {[percent]};
        key <KP5> {[greater]};
        key <KP6> {[quotedbl]};
        key <KPAD> {[braceleft]};
        key <KP1> {[colon]};
        key <KP2> {[ampersand]};
        key <KP3> {[at]};
        key <KP0> {[question]};
        key <KPDL> {[braceright]};
        key <KPEN> {[asterisk]};
        key <KPDV> {[less]};
        key <PRSC> {[dollar]};
        key <INS> {[exclam]};
        key <KPEQ> {[bar]};
        key <PAUS> {[EuroSign]};
        key <KPPT> {[asciitilde]};
      };
    '';
  };
}
