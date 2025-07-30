{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./browser.nix
    ./kitty.nix
    ./slack.nix
    ./steam.nix
  ];

  options.apps.enable = mkEnableOption "the default apps";

  config.apps = mkIf config.apps.enable {
    browser.enable = mkDefault true;
    kitty.enable = mkDefault true;
  };
}
