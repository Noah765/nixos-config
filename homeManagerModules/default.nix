{ osConfig, lib, ... }:
with lib;
{
  imports = [
    ./impermanence.nix
    ./installer.nix
  ];

  home.stateVersion = "23.11"; # Read the docs before changing

  impermanence.enable = mkIf osConfig.impermanence.enable (mkDefault true);
}
