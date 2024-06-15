{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          modules = [ ./hosts/iso/configuration.nix ];
        };
        primary = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          modules = [ ./hosts/primary/configuration.nix ];
        };
      };
    };
}
