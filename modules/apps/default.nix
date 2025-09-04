{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./browser.nix
    ./slack.nix
    ./steam.nix
    ./terminal.nix
  ];

  options.apps.enable = mkEnableOption "the default apps";

  config.apps = mkIf config.apps.enable {
    browser.enable = mkDefault true;
    terminal.enable = mkDefault true;
  };
}
