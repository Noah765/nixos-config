{
  lib,
  inputs,
  ...
}: {
  nixos = {config, ...}: {
    imports = [inputs.nix-index-database.nixosModules.default];

    options.cli.comma.enable = lib.mkEnableOption "comma";

    config.programs.nix-index-database.comma.enable = lib.mkIf config.cli.comma.enable true;
  };
}
