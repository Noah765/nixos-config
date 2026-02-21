{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.autologin.enable = lib.mkEnableOption "Autologin";

    config = lib.mkIf config.desktop.autologin.enable {
      dependencies = ["desktop.hyprland"];

      security.pam.services.autologin.name = "autologin";
      security.pam.services.autologin.startSession = true;
      systemd.services.autologin = {
        description = "Autologin";
        restartIfChanged = false;
        after = ["systemd-user-sessions.service" "plymouth-quit-wait.service"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.autologin} noah ${lib.getExe pkgs.uwsm} start -e -D Hyprland ${lib.getExe' pkgs.hyprland "start-hyprland"}";
          IgnoreSIGPIPE = "no";
          SendSIGHUP = "yes";
          TimeoutStopSec = "30s";
          KeyringMode = "shared";
          Restart = "always";
          RestartSec = "10";
        };
        startLimitBurst = 5;
        startLimitIntervalSec = 30;
        aliases = ["display-manager.service"];
      };
    };
  };
}
