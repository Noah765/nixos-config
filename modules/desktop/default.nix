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
    ./clipse.nix
  ];

  options.desktop.enable = mkEnableOption "the default window manager, display manager, etc";

  config.desktop = mkIf cfg.enable {
    stylix.enable = mkDefault true;
    sddm.enable = mkDefault true;
    hyprland.enable = mkDefault true;
    clipse.enable = mkDefault true;
  };
}
