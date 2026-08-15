{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.core.cleanup.enable = lib.mkEnableOption "the system cleanup service";
    options.core.cleanup.script = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Shell commands that make up the cleanup service.";
    };

    config.systemd = lib.mkIf (config.core.cleanup.enable && config.core.cleanup.script != "") {
      timers.cleanup.timerConfig.Persistent = true;

      services.cleanup = {
        description = "System cleanup";
        startAt = "weekly";
        after = ["multi-user.target"];
        serviceConfig.Type = "oneshot";
        path = [pkgs.nix];
        script = config.core.cleanup.script;
      };
    };
  };
}
