{
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

    config.desktop.hyprland.settings = lib.mkIf config.desktop.shell.enable {
      exec-once = lib.singleton (lib.join " " [
        "uwsm-app"
        "-s=s"
        "--"
        (lib.getExe inputs.shell.packages.${pkgs.stdenv.system}.default)
        "--wallpaper-background=${config.theme.wallpaper.background}"
        "--wallpaper-middle-ground=${config.theme.wallpaper.middleGround}"
        "--wallpaper-foreground=${config.theme.wallpaper.foreground}"
        "--background-color=${config.theme.colors.base00}"
        "--text-color=${config.theme.colors.base05}"
        "--primary-color=${config.theme.colors.green}"
        "--red=${config.theme.colors.red}"
        "--green=${config.theme.colors.green}"
        "--yellow=${config.theme.colors.yellow}"
        "--blue=${config.theme.colors.blue}"
        "--magenta=${config.theme.colors.magenta}"
        "--cyan=${config.theme.colors.cyan}"
        "--bar-opacity=${lib.toString config.theme.windowOpacity}"
      ]);

      layerrule = lib.mkIf (config.theme.windowOpacity != 1) [
        "match:namespace shell-bar, blur on"
        "match:namespace shell-bar, ignore_alpha 0"
      ];
    };
  };
}
