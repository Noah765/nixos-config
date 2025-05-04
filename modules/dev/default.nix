{
  lib,
  config,
  ...
}: {
  imports = [./flutter.nix ./nix.nix ./unity.nix];

  options.dev.enable = lib.mkEnableOption "the default development tools";

  config.dev.nix.enable = lib.mkIf config.dev.enable (lib.mkDefault true);
}
