{lib, ...}: {
  nixos = {config, ...}: {
    options.dev.enable = lib.mkEnableOption "the default development tools";

    config.dev.basic.enable = lib.mkIf config.dev.enable (lib.mkDefault true);
  };
}
