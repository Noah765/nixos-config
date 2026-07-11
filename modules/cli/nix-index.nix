{
  lib,
  inputs,
  ...
}: let
  overlay = final: _: {nix-index = inputs.nix-index-database.packages.${final.stdenv.system}.default;};
in {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "nix-index" "enable"] ["programs" "nix-index" "enable"])];
  nixos.nixpkgs.overlays = [overlay];

  perSystem.nixpkgs.overlays = [overlay];
}
