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
  inputs.nix-super.url = "github:privatevoid-net/nix-super";

  options.nix.enable = mkEnableOption "nix";

  config.os.nix = mkIf cfg.enable {
    settings = {
      substituters = [ "https://cache.privatevoid.net" ];
      trusted-public-keys = [ "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg=" ];
    };
    package = inputs.nix-super.packages.${pkgs.system}.default;
    # Simplify INSTALLABLE command line arguments, e.g. "nix shell nixpkgs#jq" becomes "nix shell jq"
    registry.default = {
      from = {
        id = "default";
        type = "indirect";
      };
      flake = inputs.nixpkgs;
    };
  };
}
