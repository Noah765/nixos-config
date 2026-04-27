{lib, ...}: {
  nixos = {config, ...}: {
    options.dev.java.enable = lib.mkEnableOption "Java";

    config.core.impermanence.hm.directories = lib.mkIf config.dev.java.enable [".m2"];
  };
}
