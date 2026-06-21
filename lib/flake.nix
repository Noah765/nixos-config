{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    lib = inputs.nixpkgs.lib.extend (final: _: {
      hm = import "${inputs.home-manager}/modules/lib" {lib = final;};
      w = import "${inputs.wrappers}/lib" {lib = final;};
      themes = import ./themes.nix;
    });
  };
}
