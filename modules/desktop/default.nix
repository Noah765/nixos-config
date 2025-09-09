{
  lib,
  config,
  ...
}: {
  imports = [./hyprland.nix];

  options.desktop.enable = lib.mkEnableOption "the desktop environment";

  config.desktop.hyprland.enable = lib.mkIf config.desktop.enable (lib.mkDefault true);
}
