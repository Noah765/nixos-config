{
  lib,
  config,
  ...
}: {
  hm.services.hyprpaper = lib.mkIf config.desktop.enable {
    enable = true;
    settings = {
      preload = [config.theme.wallpaper.outPath];
      wallpaper = [",${config.theme.wallpaper}"];
    };
  };
}
