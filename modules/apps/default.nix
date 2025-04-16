{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.apps;
in {
  imports = [
    ./firefox.nix
    ./kitty.nix
    ./slack.nix
  ];

  options.apps.enable = mkEnableOption "the default apps";

  config.apps = mkIf cfg.enable {
    firefox.enable = mkDefault true;
    kitty.enable = mkDefault true;
  };
}
