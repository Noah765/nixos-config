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

    config.hm.systemd.user.services.app-shell = lib.mkIf config.desktop.shell.enable {
      Unit.Description = "shell";
      Unit.After = ["graphical-session.target"];
      Service.ExecStart = lib.getExe pkgs.desktop-shell;
      Service.Restart = "on-failure";
      Install.WantedBy = ["graphical-session.target"];
    };
  };

  flake.wrappers.desktop-shell = {pkgs, ...}: {
    imports = [wlib.modules.default];

    package = inputs.shell.packages.${pkgs.stdenv.system}.default;

    flags = {
      "--wallpaper-background" = ../../wallpapers/everforest/background.png;
      "--wallpaper-middle-ground" = ../../wallpapers/everforest/middle-ground.png;
      "--wallpaper-foreground" = ../../wallpapers/everforest/foreground.png;
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
