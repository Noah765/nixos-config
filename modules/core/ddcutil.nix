{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; let
  cfg = config.core.ddcutil;
in {
  options.core.ddcutil.enable = mkEnableOption "ddcutil for controlling displays";

  config = mkIf cfg.enable {
    # TODO Substitute with module definition?
    os.hardware.i2c.enable = true;
    core.user.groups = ["i2c"];

    os = {
      environment.systemPackages = [pkgs.ddcutil];
      boot.extraModulePackages = [osConfig.boot.kernelPackages.ddcci-driver];

      services.udev.extraRules = ''
        SUBSYSTEM=="i2c-dev", ACTION=="add",\
          ATTR{name}=="NVIDIA i2c adapter*",\
          TAG+="ddcci",\
          TAG+="systemd",\
          ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
      '';

      systemd.services."ddcci@" = {
        scriptArgs = "%i";
        script = ''
          echo Trying to attach ddcci to $1
          i=0
          id=$(echo $1 | cut -d "-" -f 2)
          counter=5
          while [ $counter -gt 0 ]; do
            if ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $id; then
              echo ddcci 0x37 > /sys/bus/i2c/devices/$1/new_device
              break
            fi
            sleep 1
            counter=$((counter - 1))
          done
        '';
        serviceConfig.Type = "oneshot";
      };
    };
  };
}
