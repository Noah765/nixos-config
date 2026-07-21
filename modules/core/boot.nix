{lib, ...}: {
  nixos = {config, ...}: {
    options.core.boot.enable = lib.mkEnableOption "the default boot configuration";

    config.boot.loader = lib.mkIf config.core.boot.enable {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };
}
