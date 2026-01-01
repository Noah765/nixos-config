{
  lib,
  pkgs,
  config,
  ...
}: {
  options.desktop.autologin.enable = lib.mkEnableOption "Autologin";

  config = lib.mkIf config.desktop.autologin.enable {
    dependencies = ["desktop.hyprland"];

    os.security.pam.services.autologin = {
      name = "autologin";
      startSession = true;
    };
    os.systemd.services.autologin = {
      description = "Autologin";
      restartIfChanged = false;
      after = ["systemd-user-sessions.service" "plymouth-quit-wait.service"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.autologin} noah ${lib.getExe pkgs.uwsm} start ${lib.getExe config.os.programs.hyprland.package}";
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
}
