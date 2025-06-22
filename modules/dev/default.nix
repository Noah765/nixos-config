{
  lib,
  config,
  ...
}: {
  imports = [./basic.nix ./flutter.nix ./nix.nix ./rust.nix ./unity.nix];

  options.dev.enable = lib.mkEnableOption "the default development tools";

  config.dev = lib.mkIf config.dev.enable {
    basic.enable = lib.mkDefault true;
    nix.enable = lib.mkDefault true;
  };
}
