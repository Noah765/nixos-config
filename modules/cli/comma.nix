{
  lib,
  inputs,
  config,
  ...
}: {
  inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  osImports = [inputs.nix-index-database.nixosModules.nix-index];

  options.cli.comma.enable = lib.mkEnableOption "comma";

  config.os.programs.nix-index-database.comma.enable = lib.mkIf config.cli.comma.enable true;
}
