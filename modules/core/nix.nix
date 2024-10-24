{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.core.nix;
in {
  inputs.nix-dram = {
    url = "github:dramforever/nix-dram";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  options.core.nix.enable = mkEnableOption "a patched version of the Nix language and core settings required for Nix";

  config = mkIf cfg.enable {
    hm.home.stateVersion = "24.11";

    os = {
      system.stateVersion = "24.11";

      nix = {
        settings = {
          experimental-features = ["nix-command" "flakes"];
          default-flake = inputs.nixpkgs;
        };
        channel.enable = false;
        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      };

      nixpkgs = {
        config.allowUnfree = true;

        overlays = [
          (final: prev: {
            nix = inputs.nix-dram.packages.${pkgs.system}.default.overrideAttrs (old: {
              patches =
                old.patches
                or []
                ++ [
                  (pkgs.fetchpatch {
                    url = "https://raw.githubusercontent.com/Noah765/combined-manager/main/nix-patches/2.24.4/evaluable-flake.patch";
                    hash = "sha256-72mFg401gUMeSRMqxdcFhW4e4FCFMMz2AFhwoxqg8oc=";
                  })
                ];
            });
          })
        ];
      };
    };
  };
}
