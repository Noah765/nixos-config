let
  combinedManager = import (
    builtins.fetchTarball {
      url = "https://github.com/flafydev/combined-manager/archive/725f45b519187d6e1a49fe4d92b75d32b0d05687.tar.gz";
      sha256 = "sha256:0kkwx01m5a28sd0v41axjypmiphqfhnivl8pwk9skf3c1aarghfb";
    }
  );
in
combinedManager.mkFlake {
  description = "NixOS configuration";

  lockFile = ./flake.lock;

  initialInputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-super.url = "github:Noah765/nix-super/evaluable-flake-thunk"; # TODO Use https://github.com/privatevoid-net/nix-super, once https://github.com/privatevoid-net/nix-super/pull/19 gets merged

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    bird-nix-lib = {
      url = "github:spikespaz/bird-nix-lib";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprnix = {
      url = "github:hyprland-community/hyprnix";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        hyprland.follows = "hyprland";
        hyprland-protocols.follows = "hyprland/xdph/hyprland-protocols";
        hyprland-xdph.follows = "hyprland/xdph";
        hyprlang.follows = "hyprland/hyprlang";
        bird-nix-lib.follows = "bird-nix-lib";
      };
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
  };

  configurations = {
    primary = {
      system = "x86_64-linux";
      modules = [
        ./hosts/primary/configuration.nix
        ./modules
      ];
    };
    iso = {
      system = "x86_64-linux";
      useHomeManager = false; # TODO: Working?
      modules = [
        ./hosts/iso/configuration.nix
        ./modules
      ];
    };
  };
}
