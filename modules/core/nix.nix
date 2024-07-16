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
  inputs.nix-dram.url = "github:dramforever/nix-dram";

  options.nix.enable = mkEnableOption "nix";

  config.os = mkIf cfg.enable {
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

      gc = {
        automatic = true;
        dates = "monthly";
        options = "--delete-older-than 30d";
      };

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        auto-optimise-store = true;

        default-flake = "github:NixOS/nixpkgs/nixos-unstable";
      };
    };
  };
}
