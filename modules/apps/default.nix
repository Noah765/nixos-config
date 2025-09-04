{
  lib,
  config,
  ...
}: {
  imports = [
    ./browser.nix
    ./slack.nix
    ./steam.nix
    ./terminal.nix
  ];

  options.apps.enable = lib.mkEnableOption "the default apps";

  config.apps = lib.mkIf config.apps.enable {
    browser.enable = lib.mkDefault true;
    terminal.enable = lib.mkDefault true;
  };
}
