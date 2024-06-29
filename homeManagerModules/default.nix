{ osConfig, lib, ... }:
with lib;
{
  imports = [
    ./impermanence.nix
    ./zsh.nix
    ./git.nix
    ./installer.nix
  ];

  home.stateVersion = "23.11"; # Read the docs before changing

  impermanence.enable = mkIf osConfig.impermanence.enable (mkDefault true);
  zsh.enable = mkIf osConfig.zsh.enable (mkDefault true);
  git.enable = mkDefault true;
}
