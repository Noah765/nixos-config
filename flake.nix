{
  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    file-manager-theme.url = "github:Chromium-3-Oxide/everforest-medium.yazi";
    file-manager-theme.flake = false;
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    greasemonkey-scripts.url = "github:afreakk/greasemonkeyscripts";
    greasemonkey-scripts.flake = false;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hy3.url = "github:outfoxxed/hy3/hl0.54.2";
    hy3.inputs.hyprland.follows = "hyprland";
    hypr-darkwindow.url = "github:micha4w/Hypr-DarkWindow/v0.54.2";
    hypr-darkwindow.inputs.hyprland.follows = "hyprland";
    hyprland.url = "github:hyprwm/Hyprland/v0.54.2";
    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs = {
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    nestix.url = "github:Noah765/nestix";
    nestix.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    ublock-origin-assets.url = "github:uBlockOrigin/uAssets";
    ublock-origin-assets.flake = false;
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
