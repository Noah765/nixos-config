{ lib, ... }:
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
    ./docs.nix
    ./hyprland.nix
  ];

  # Read the docs before changing
  os.system.stateVersion = "24.11";
  hm.home.stateVersion = "24.11";

  hmUsername = "noah";

  impermanence.enable = mkDefault true;
  bootloader.enable = mkDefault true;
  networking.enable = mkDefault true;
  audio.enable = mkDefault true;
  user.enable = mkDefault true;
  zsh.enable = mkDefault true;
  localization.enable = mkDefault true;
  docs.enable = mkDefault true;
}
