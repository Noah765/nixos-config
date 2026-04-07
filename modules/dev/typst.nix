{lib, ...}: {
  nixos = {config, ...}: {
    options.dev.typst.enable = lib.mkEnableOption "Typst";

    config.core.impermanence.hm.directories = lib.mkIf config.dev.typst.enable [".cache/typst"];
  };
}
