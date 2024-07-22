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
  ];

  options.desktop.enable = mkEnableOption "the default window manager, display manager, app runner, etc";

  config.desktop = mkIf cfg.enable {
    stylix.enable = mkDefault true;
    sddm.enable = mkDefault true;
    hyprland.enable = mkDefault true;
    walker.enable = mkDefault true;
  };
}
