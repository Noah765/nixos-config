{lib, ...}: {
  nixos = {config, ...}: {
    options.desktop.enable = lib.mkEnableOption "the desktop environment";

    config.desktop = lib.mkIf config.desktop.enable {
      autologin.enable = lib.mkDefault true;
      cursor.enable = lib.mkDefault true;
      fonts.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
      qt.enable = lib.mkDefault true;
      shell.enable = lib.mkDefault true;
    };
  };
}
