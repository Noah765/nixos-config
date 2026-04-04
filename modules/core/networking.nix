{lib, ...}: {
  nixos = {config, ...}: {
    options.core.networking.enable = lib.mkEnableOption "Networking";
    options.core.networking.hostName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the machine.";
    };

    config = lib.mkIf config.core.networking.enable {
      networking.hostName = config.core.networking.hostName;
      networking.networkmanager.enable = true;
      core.user.groups = ["networkmanager"];
      core.impermanence.os.directories = ["/etc/NetworkManager/system-connections"];
    };
  };
}
