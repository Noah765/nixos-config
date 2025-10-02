{
  lib,
  config,
  ...
}: {
  options.core.networking = {
    enable = lib.mkEnableOption "Networking";
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the machine.";
    };
  };

  config = lib.mkIf config.core.networking.enable {
    os.networking.hostName = config.core.networking.hostName;
    os.networking.wireless = {
      enable = true;
      secretsFile = "/var/keys/wireless.conf";
      userControlled.enable = true;
      networks = {
        CHE.pskRaw = "ext:CHE";
        mieter.pskRaw = "ext:mieter";
        eduroam.auth = ''
          key_mgmt=WPA-EAP
          eap=PEAP
          phase2="auth=MSCHAPV2"
          identity="nlandgraf@student-net.ethz.ch"
          password=ext:eduroam
        '';
      };
    };
    core.impermanence.os.files = [
      {
        file = "/var/keys/wireless.conf";
        parentDirectory.mode = "u=rwx,g=,o=";
      }
    ];
  };
}
