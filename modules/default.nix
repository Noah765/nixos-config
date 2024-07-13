{ lib, ... }:
with lib;
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [
    ./core
    ./zsh.nix
    ./localization.nix
    ./docs.nix
    ./hyprland.nix
    ./programs
  ];

  hmUsername = "noah";

  zsh.enable = mkDefault true;
  localization.enable = mkDefault true;
  docs.enable = mkDefault true;
}
