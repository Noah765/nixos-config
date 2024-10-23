{
  lib,
  config,
  ...
}:
with lib; {
  hm.services.hyprpaper = mkIf config.desktop.enable {
    enable = true;
    settings = {
      preload = [config.theme.wallpaper.outPath];
      wallpaper = [",${config.theme.wallpaper}"];
    };
  };
}
