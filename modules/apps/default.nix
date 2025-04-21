{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./firefox.nix
    ./kitty.nix
    ./slack.nix
  ];

  options.apps.enable = mkEnableOption "the default apps";

  config.apps = mkIf config.apps.enable {
    firefox.enable = mkDefault true;
    kitty.enable = mkDefault true;
  };
}
