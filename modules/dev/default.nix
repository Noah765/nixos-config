{lib, ...}: {
  nixos = {config, ...}: {
    options.dev.enable = lib.mkEnableOption "the default development tools";

    config.dev = lib.mkIf config.dev.enable {
      basic.enable = lib.mkDefault true;
      markdown.enable = lib.mkDefault true;
      nix.enable = lib.mkDefault true;
    };
  };
}
