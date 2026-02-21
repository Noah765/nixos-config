{lib, ...}: {
  nixos = {config, ...}: {
    options.apps.enable = lib.mkEnableOption "the default apps";

    config.apps = lib.mkIf config.apps.enable {
      browser.enable = lib.mkDefault true;
      terminal.enable = lib.mkDefault true;
    };
  };
}
