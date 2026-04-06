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

    config.desktop.hyprland.settings.exec-once = lib.mkIf config.desktop.shell.enable (lib.singleton (lib.join " " [
      (lib.getExe inputs.shell.packages.${pkgs.stdenv.system}.default)
      "--wallpaper-background=${config.theme.wallpaper.background}"
      "--wallpaper-middle-ground=${config.theme.wallpaper.middleGround}"
      "--wallpaper-foreground=${config.theme.wallpaper.foreground}"
      "--background-color=${config.theme.colors.base00}"
      "--text-color=${config.theme.colors.base05}"
      "--primary-color=${config.theme.colors.base0B}"
      "--bar-opacity=${lib.toString config.theme.windowOpacity}"
    ]));
  };
}
