{
  description = "Nixos config flake";

  inputs = {
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

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprscroller = {
      url = "github:dawsers/hyprscroller";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations =
        let
          buildHmConfig = name: self.nixosConfigurations.${name}.config.home-manager.users.noah or { };
        in
        {
          primary = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              hmConfig = buildHmConfig "primary";
            };
            modules = [
              ./hosts/primary/configuration.nix
              ./nixosModules
            ];
          };
          iso = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              hmConfig = buildHmConfig "iso";
            };
            modules = [
              ./hosts/iso/configuration.nix
              ./nixosModules
            ];
          };
        };

      homeManagerModules.default = ./homeManagerModules;
    };
}
