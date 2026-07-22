{lib, ...}: {
  nixos = {config, ...}: {
    options.apps.enable = lib.mkEnableOption "the default apps";

    config.apps = lib.mkIf config.apps.enable {
      ghostty.enable = lib.mkDefault true;
      qutebrowser.enable = lib.mkDefault true;
    };
  };
}
