{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  imports = [
    ./stylix.nix
    ./sddm.nix
    ./hyprland.nix
    ./walker.nix
    ./waybar.nix
  ];

  options.desktop.enable = mkEnableOption "the default window manager, display manager, app runner, status bar, etc";

  config.desktop = mkIf cfg.enable {
    stylix.enable = mkDefault true;
    sddm.enable = mkDefault true;
    hyprland.enable = mkDefault true;
    walker.enable = mkDefault true;
    waybar.enable = mkDefault true;
  };
}
