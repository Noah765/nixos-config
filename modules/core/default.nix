{ lib, ... }:
with lib;
{
  imports = [
    ./nix.nix
    ./impermanence.nix
    ./bootloader.nix
    ./networking.nix
    ./audio.nix
    ./nvidia.nix
    ./user.nix
  ];

  nix.enable = mkDefault true;
  impermanence.enable = mkDefault true;
  bootloader.enable = mkDefault true;
  networking.enable = mkDefault true;
  audio.enable = mkDefault true;
  user.enable = mkDefault true;
}
