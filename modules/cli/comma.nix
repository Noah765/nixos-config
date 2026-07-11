{
  lib,
  inputs,
  ...
}: let
  overlay = final: _: {comma = inputs.nix-index-database.packages.${final.stdenv.system}.comma-with-db;};
in {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.comma.enable = lib.mkEnableOption "comma";

    config.nixpkgs.overlays = [overlay];
    config.environment.systemPackages = lib.mkIf config.cli.comma.enable [pkgs.comma];
  };

  perSystem.nixpkgs.overlays = [overlay];
}
