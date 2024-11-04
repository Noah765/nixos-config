{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.apps;
in {
  imports = [
    ./kitty.nix
    ./firefox.nix
    ./unity.nix
  ];

  options.apps.enable = mkEnableOption "the default apps";

  config.apps = mkIf cfg.enable {
    kitty.enable = mkDefault true;
    firefox.enable = mkDefault true;
  };
}
