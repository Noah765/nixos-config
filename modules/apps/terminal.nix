{
  lib,
  wlib,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["apps" "terminal" "enable"] ["wrappers" "terminal" "enable"])];

  flake.wrappers.terminal = {
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];

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
      lib.generators.toKeyValue {
        mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
        listsAsDuplicateKeys = true;
      } {
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
        app-notifications = "no-clipboard-copy";

        background = "#2d353b";
        foreground = "#d3c6aa";
        cursor-color = "#d3c6aa";
        selection-background = "#475258";
        selection-foreground = "#d3c6aa";

        palette = [
          "0=#2d353b"
          "1=#e67e80"
          "2=#a7c080"
          "3=#dbbc7f"
          "4=#7fbbb3"
          "5=#d699b6"
          "6=#83c092"
          "7=#d3c6aa"
          "8=#859289"
          "9=#e67e80"
          "10=#a7c080"
          "11=#dbbc7f"
          "12=#7fbbb3"
          "13=#d699b6"
          "14=#83c092"
          "15=#fdf6e3"
        ];

        keybind = [
          "clear"
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+0=reset_font_size"
          "ctrl++=increase_font_size:1"
          "ctrl+-=decrease_font_size:1"
        ];
      };
  };
}
