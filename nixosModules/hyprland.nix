{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.hyprland;
in
{
  options.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}
