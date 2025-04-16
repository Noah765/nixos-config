{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.desktop;
in {
  imports = [
    ./stylix.nix
    ./sddm.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./clipse.nix
  ];

  options.desktop.enable = mkEnableOption "the desktop environment";

  config = mkIf cfg.enable {
    desktop = {
      # TODO Remove the enable options of the individual parts of my DE, and expose options as DE options as necessary
      #stylix.enable = mkDefault true;
      sddm.enable = mkDefault true;
      hyprland.enable = mkDefault true;
      clipse.enable = mkDefault true;
    };
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
