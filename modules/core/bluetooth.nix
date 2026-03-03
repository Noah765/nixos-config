{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.core.bluetooth.enable = lib.mkEnableOption "Bluetooth support";

    config = lib.mkIf config.core.bluetooth.enable {
      hardware.bluetooth.enable = true;
      hm.home.packages = [pkgs.bluetui];
      core.impermanence.os.directories = ["/var/lib/bluetooth"];
    };
  };
}
