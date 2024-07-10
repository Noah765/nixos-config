let
  # combinedManager = builtins.getFlake "github:Noah765/combined-manager/de37fac80eea195dfdf768ab442b3f8d89157de9";
  # combinedManager = builtins.getFlake "";
  #combinedManager = import (builtins.fetchTarball {
  #  url = "https://github.com/Noah765/combined-manager/archive/de37fac80eea195dfdf768ab442b3f8d89157de9.tar.gz";
  #  sha256 = "sha256:1rnyc89x363l402yiz91wzfnls52yhsqkvdjwr05jr5dgas8hvfl";
  #});
  combinedManager = import ./combined-manager;
in
combinedManager.mkFlake {
  description = "NixOS configuration";
  lockFile = ./flake.lock;
  system = "x86_64-linux";

  initialInputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:tmarkov/impermanence"; # TODO: Change to nix-community when they fixed https://github.com/nix-community/impermanence/issues/154

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nix-super.url = "github:Noah765/nix-super/evaluable-flake-thunk"; # TODO Use https://github.com/privatevoid-net/nix-super, once https://github.com/privatevoid-net/nix-super/pull/19 gets merged
    nix-super.url = "path:/home/noah/Downloads/nix-super";

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
    primary.modules = [
      #{
      #  hmUsername = "noah";
      #osImports = [
      #  ./nixosModules
      #  ./hosts/primary/configuration.nix
      #];
      #}
      ./modules
      ./hosts/primary/configuration.nix
    ];
  };

  outputs =
    { self, ... }@inputs:
    {
      #    nixosConfigurations =
      #      let
      #        buildHmConfig = name: self.nixosConfigurations.${name}.config.home-manager.users.noah or { };
      #     in
      #      {
      #        primary = inputs.nixpkgs.lib.nixosSystem {
      #          specialArgs = {
      #            inherit inputs;
      #            hmConfig = buildHmConfig "primary";
      #          };
      #          modules = [
      #            ./hosts/primary/configuration.nix
      #            ./nixosModules
      #          ];
      #        };
      #        iso = {
      #          #useHomeManager = false; # TODO: Working?
      #          modules = [
      #            ./hosts/iso/configuration.nix
      #            ./modules
      #          ];
      #        };
      #      };

      homeManagerModules.default = ./homeManagerModules;
    };
}
