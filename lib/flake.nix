{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    to-toml.url = "https://raw.githubusercontent.com/flibrary/sails/refs/heads/main/to-toml.nix";
    to-toml.flake = false;
  };

  outputs = inputs: {
    lib = inputs.nixpkgs.lib.extend (final: prev: {
      hm = import "${inputs.home-manager}/modules/lib" {lib = final;};
      w = import "${inputs.wrappers}/lib" {lib = final;};
      themes = import ./themes.nix;
      generators = prev.generators // {toToml = _: import inputs.to-toml {lib = final;};};
    });
  };
}
