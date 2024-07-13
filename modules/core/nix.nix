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
  options.nix.enable = mkEnableOption "nix";

  config.os = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    nix.package = pkgs.nix.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/Noah765/combined-manager/main/evaluable-flake.patch";
          hash = "sha256-UZ5hXI1w1mOEe0Bp5rSfeB4jfnwxnNEXJWir4dQGyyo=";
        })
      ];
    });
  };
}
