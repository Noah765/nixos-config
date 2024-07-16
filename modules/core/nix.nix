{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.nix;
in
{
  inputs = {
    nix-dram = {
      url = "github:dramforever/nix-dram";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  hmImports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.nix.enable = mkEnableOption "nix";

  config = mkIf cfg.enable {
    os = mkIf cfg.enable {
      nixpkgs.config.allowUnfree = true;

      nix = {
        package = (inputs.nix-dram.packages.${pkgs.system}.default).overrideAttrs (old: {
          patches = old.patches or [ ] ++ [
            (pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/Noah765/combined-manager/main/nix-patches/2.22.1/evaluable-flake.patch";
              hash = "sha256-/VoR8Ygm4bHPVqNz7PkKMoptDSqV666R0xza/YBfKEE=";
            })
          ];
        });

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
          default-flake = "github:NixOS/nixpkgs/nixos-unstable";
        };
      };

      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "-k 5 -K 7d";
        };
        flake = "/etc/nixos";
      };
    };

    hm = {
      home.packages = with pkgs; [
        deadnix
        nixfmt-rfc-style
        nix-output-monitor
      ];

      programs.nix-index-database.comma.enable = true;
    };
  };
}
