{lib, ...}: {
  nixos = {config, ...}: {
    options.desktop.autologin.enable = lib.mkEnableOption "Autologin";

    config.services.getty.autologinUser = lib.mkIf config.desktop.autologin.enable "noah";
  };
}
