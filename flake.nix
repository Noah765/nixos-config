let
  # TODO Put combined manager itself as a flake input for automatic updating?
  #combinedManager = builtins.getFlake "github:Noah765/combined-manager/b81722f0816d92e3d61d260a8a76b4434f8c505b";
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
      ./modules
      ./hosts/primary/configuration.nix
    ];
  };
}
