{
  lib,
  config,
  ...
}: {
  imports = [./hyprland.nix ./hyprpaper.nix];

  options.desktop.enable = lib.mkEnableOption "the desktop environment";

  config = lib.mkIf config.desktop.enable {
    # TODO Remove the enable options of the individual parts of my DE, and expose options as DE options as necessary
    desktop.hyprland.enable = lib.mkDefault true;
    os.fonts = let
      inherit (config.theme.fonts) serif sansSerif monospace emoji;
    in {
      packages = [serif.package sansSerif.package monospace.package emoji.package];
      fontconfig.defaultFonts = {
        serif = [serif.name];
        sansSerif = [sansSerif.name];
        monospace = [monospace.name];
        emoji = [emoji.name];
      };
    };
    hm.home.pointerCursor = {
      inherit (config.theme.cursor) package name size;
      gtk.enable = true;
    };
    hm.dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
