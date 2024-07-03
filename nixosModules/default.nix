{
  inputs,
  pkgs,
  lib,
  ...
}:
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
    ./homeManager.nix
    ./hyprland.nix
  ];

  system.stateVersion = "23.11"; # Read the docs before changing

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    substituters = [ "https://cache.privatevoid.net" ];
    trusted-public-keys = [ "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg=" ];
  };
  nix.package = inputs.nix-super.packages.${pkgs.system}.default;
  # Simplify INSTALLABLE command line arguments, e.g. "nix shell nixpkgs#jq" becomes "nix shell jq"
  nix.registry.default = {
    from = {
      id = "default";
      type = "indirect";
    };
    flake = inputs.nixpkgs;
  };

  impermanence.enable = mkDefault true;
  bootloader.enable = mkDefault true;
  networking.enable = mkDefault true;
  audio.enable = mkDefault true;
  user.enable = mkDefault true;
  zsh.enable = mkDefault true;
  localization.enable = mkDefault true;
  docs.enable = mkDefault true;
  homeManager.enable = mkDefault true;
}
