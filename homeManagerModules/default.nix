{ osConfig, lib, ... }:
with lib;
{
  imports = [
    ./installer.nix
    ./impermanence.nix
    ./zsh.nix
    ./localization.nix
    ./hyprland.nix
    ./git.nix
    ./kitty.nix
    ./firefox.nix
    ./slack.nix
  ];

  home.stateVersion = "23.11"; # Read the docs before changing

  impermanence.enable = mkIf osConfig.impermanence.enable (mkDefault true);
  zsh.enable = mkIf osConfig.zsh.enable (mkDefault true);
  localization.enable = mkIf osConfig.localization.enable (mkDefault true);
  hyprland.enable = mkIf osConfig.hyprland.enable (mkDefault true);
  git = {
    enable = mkDefault true;
    gitHub = mkDefault true;
  };
  kitty.enable = mkDefault true;
  firefox.enable = mkDefault true;
}
