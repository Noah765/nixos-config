{
  lib,
  config,
  ...
}: {
  imports = [./autologin.nix ./hyprland.nix ./hyprsunset.nix ./quickshell];

  options.desktop.enable = lib.mkEnableOption "the desktop environment";

  config.desktop = lib.mkIf config.desktop.enable {
    autologin.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
    hyprsunset.enable = lib.mkDefault true;
    quickshell.enable = lib.mkDefault true;
  };
}
