{
  lib,
  config,
  ...
}: {
  options.core.networkmanager = {
    enable = lib.mkEnableOption "NetworkManager";
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the machine.";
    };
  };

  config = lib.mkIf config.core.networkmanager.enable {
    os.networking = {
      inherit (config.core.networkmanager) hostName;
      wireless.enable = false; # The iso config has this enabled by default
      networkmanager.enable = true;
    };
    core.user.groups = ["networkmanager"];
    core.impermanence.os.directories = ["/etc/NetworkManager/system-connections"];
  };
}
