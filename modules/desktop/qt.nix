{lib, ...}: {
  nixos = {config, ...}: {
    options.desktop.qt.enable = lib.mkEnableOption "configuring Qt";

    config.hm.qt = lib.mkIf config.desktop.qt.enable {
      enable = true;
      qt5ctSettings.Appearance.standard_dialogs = "xdgdesktopportal";
      qt6ctSettings.Appearance.standard_dialogs = "xdgdesktopportal";
    };
  };
}
