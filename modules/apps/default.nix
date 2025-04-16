{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.apps;
in {
  imports = [
    ./kitty.nix
    ./firefox.nix
    ./slack.nix
  ];

  options.apps.enable = mkEnableOption "the default apps";

  config.apps = mkIf cfg.enable {
    kitty.enable = mkDefault true;
    firefox.enable = mkDefault true;
  };
}
