{
  lib,
  inputs,
  config,
  ...
}:
with lib; let
  cfg = config.cli.comma;
in {
  inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  osImports = [inputs.nix-index-database.nixosModules.nix-index];

  options.cli.comma.enable = mkEnableOption "comma";

  config.os.programs.nix-index.database.comma = mkIf cfg.enable true;
}
