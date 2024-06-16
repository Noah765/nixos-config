{ inputs, lib, ... }:
with lib;
{
  imports = [
    ./impermanence.nix
    ./bootLoader.nix
    ./audio.nix
    ./homeManager.nix
    ./localization.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  impermanence.enable = mkDefault true;
  bootLoader.enable = mkDefault true;
  audio.enable = mkDefault true;
  homeManager.enable = mkDefault true;
  localization.enable = mkDefault true;
}
