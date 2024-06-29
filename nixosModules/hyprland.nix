{ lib, config, ... }:
with lib;
let
  cfg = config.hyprland;
in
{
  options.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable { programs.hyprland.enable = true; };
}
