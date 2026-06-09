{
  wlib,
  lib,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.shell.enable = lib.mkEnableOption "the desktop shell";

    config = lib.mkIf config.desktop.shell.enable {
      hm.systemd.user.services.app-shell = {
        Unit.Description = "shell";
        Unit.After = ["graphical-session.target"];
        Service.ExecStart = lib.getExe pkgs.desktop-shell;
        Service.Restart = "on-failure";
        Install.WantedBy = ["graphical-session.target"];
      };

      desktop.hyprland.settings.layer_rule = lib.singleton {
        match.namespace = "shell-(bar|calculator)";
        blur = true;
        ignore_alpha = 0;
      };
    };
  };

  flake.wrappers.desktopShell = {pkgs, ...}: {
    imports = [wlib.modules.default];

    package = inputs.shell.packages.${pkgs.stdenv.system}.default;

    flags = {
      "--wallpaper-background" = ../theme/everforest/wallpaper-background.png;
      "--wallpaper-middle-ground" = ../theme/everforest/wallpaper-middle-ground.png;
      "--wallpaper-foreground" = ../theme/everforest/wallpaper-foreground.png;
      "--background-color" = "#2d353b";
      "--text-color" = "#d3c6aa";
      "--primary-color" = "#a7c080";
      "--red" = "#e67e80";
      "--green" = "#a7c080";
      "--yellow" = "#dbbc7f";
      "--blue" = "#7fbbb3";
      "--magenta" = "#d699b6";
      "--cyan" = "#83c092";
      "--bar-opacity" = "0.75";
    };
  };
}
