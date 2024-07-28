let
  inherit
    ((builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.combined-manager.locked)
    rev
    narHash
    ;
  combinedManager = import (builtins.fetchTarball {
    url = "https://github.com/Noah765/combined-manager/archive/${rev}.tar.gz";
    sha256 = narHash;
  });
in
  combinedManager.mkFlake {
    lockFile = ./flake.lock;

    initialInputs = {
      combined-manager.url = "github:Noah765/combined-manager";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    globalModules = [./modules];

    configurations = {
      primary.modules = [./hosts/primary/configuration.nix];
      iso.modules = [./hosts/iso/configuration.nix];
    };
  }
