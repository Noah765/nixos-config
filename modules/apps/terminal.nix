{
  lib,
  wlib,
  ...
}: {
  nixos = {config, ...}: {
    options.apps.terminal.enable = lib.mkEnableOption "Ghostty";

    config = lib.mkIf config.apps.terminal.enable {
      wrappers.terminal.enable = true;
      desktop.hyprland.bind = [["SUPER + T" "hl.dsp.exec_raw('ghostty +new-window')"]]; # Ghostty natively sets up systemd services
    };
  };

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
    constructFiles.config.content = ''
      font-family = JetBrainsMono Nerd Font Mono
      font-family = DejaVu Sans Mono
      font-family = Unifont
      font-size = 10.5
      mouse-scroll-multiplier = 0.75
      window-padding-x = 0
      window-padding-y = 0
      window-padding-balance = true
      confirm-close-surface = false
      app-notifications = no-clipboard-copy

      background = 2d353b
      foreground = d3c6aa
      cursor-color = d3c6aa
      selection-background = 475258
      selection-foreground = d3c6aa

      palette = 0=2d353b
      palette = 1=e67e80
      palette = 2=a7c080
      palette = 3=dbbc7f
      palette = 4=7fbbb3
      palette = 5=d699b6
      palette = 6=83c092
      palette = 7=d3c6aa
      palette = 8=859289
      palette = 9=e67e80
      palette = 10=a7c080
      palette = 11=dbbc7f
      palette = 12=7fbbb3
      palette = 13=d699b6
      palette = 14=83c092
      palette = 15=fdf6e3
    '';
  };
}
