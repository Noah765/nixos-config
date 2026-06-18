{lib, ...} @ flake: let
  configGenerator = lib.generators.toKeyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
    listsAsDuplicateKeys = true;
  };
in {
  nixos.imports = [(lib.mkAliasOptionModule ["apps" "terminal" "enable"] ["wrappers" "terminal" "enable"])];

  theme."config.ghostty" = theme:
    configGenerator {
      background = theme.bg;
      foreground = theme.fg;
      cursor-color = theme.cursor;
      cursor-text = theme.cursorText;
      selection-background = theme.selectionBg;
      selection-foreground = "cell-foreground";

      palette = [
        "0=${theme.black}"
        "1=${theme.red}"
        "2=${theme.green}"
        "3=${theme.yellow}"
        "4=${theme.blue}"
        "5=${theme.magenta}"
        "6=${theme.cyan}"
        "7=${theme.white}"
        "8=${theme.brightBlack}"
        "9=${theme.brightRed}"
        "10=${theme.brightGreen}"
        "11=${theme.brightYellow}"
        "12=${theme.brightBlue}"
        "13=${theme.brightMagenta}"
        "14=${theme.brightCyan}"
        "15=${theme.brightWhite}"
      ];
    };

  flake.wrappers.terminal = {
    pkgs,
    config,
    ...
  }: {
    imports = [lib.w.modules.default];

    package = pkgs.ghostty;

    filesToPatch = [
      "share/dbus-1/services/com.mitchellh.ghostty.service"
      "share/systemd/user/app-com.mitchellh.ghostty.service"
    ];

    flagSeparator = "=";
    flags."--config-default-files" = "false";
    flags."--config-file" = config.constructFiles.config.path;

    constructFiles.config.relPath = "${config.binName}-config";
    constructFiles.config.content =
      configGenerator {
        config-file = "?~/.theme-config/config.ghostty";

        font-family = [
          "JetBrainsMono Nerd Font Mono"
          "DejaVu Sans Mono"
          "Unifont"
        ];
        font-size = 10.5;
        mouse-scroll-multiplier = 0.75;
        window-padding-x = 0;
        window-padding-y = 0;
        window-padding-balance = true;
        confirm-close-surface = false;
        app-notifications = false;

        keybind = [
          "clear"
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+0=reset_font_size"
          "ctrl++=increase_font_size:1"
          "ctrl+-=decrease_font_size:1"
          "ctrl+,=reload_config"
        ];
      }
      + flake.config.defaultTheme."config.ghostty";
  };
}
