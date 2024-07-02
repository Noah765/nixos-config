{ lib, config, ... }:
with lib;
let
  cfg = config.hyprland;
in
{
  options.hyprland.enable = mkEnableOption "hyprland";

  config.programs.hyprland.enable = mkIf cfg.enable true;
}
