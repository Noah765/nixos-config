{ inputs, lib, ... }:
with lib;
{
  imports = [
    ./impermanence.nix
    ./bootloader.nix
    ./networking.nix
    ./audio.nix
    ./nvidia.nix
    ./user.nix
    ./zsh.nix
    ./localization.nix
    ./homeManager.nix
    ./hyprland.nix
  ];

  system.stateVersion = "23.11"; # Read the docs before changing

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  impermanence.enable = mkDefault true;
  bootloader.enable = mkDefault true;
  networking.enable = mkDefault true;
  audio.enable = mkDefault true;
  user.enable = mkDefault true;
  zsh.enable = mkDefault true;
  localization.enable = mkDefault true;
  homeManager.enable = mkDefault true;
}
