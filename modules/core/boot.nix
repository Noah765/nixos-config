{lib, ...}: {
  nixos = {config, ...}: {
    options.core.boot.enable = lib.mkEnableOption "the default boot configuration";

    config = lib.mkIf config.core.boot.enable {
      boot.loader.systemd-boot = {
        enable = true;
        editor = false;
      };
      boot.loader.efi.canTouchEfiVariables = true;

      # See https://github.com/NixOS/nixpkgs/pull/51338
      systemd.additionalUpstreamSystemUnits = ["systemd-time-wait-sync.service"];
      systemd.services.systemd-time-wait-sync.wantedBy = ["sysinit.target"];
    };
  };
}
