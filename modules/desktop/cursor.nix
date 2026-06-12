{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.cursor.enable = lib.mkEnableOption "configuring the cursor";

    config = lib.mkIf config.desktop.cursor.enable {
      hm.home.pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
        gtk.enable = true;
      };

      environment.variables.XCURSOR_SIZE = 24;
    };
  };
}
