{lib, ...}: {
  nixos = {config, ...}: {
    options.cli.docker.enable = lib.mkEnableOption "Docker";

    config = lib.mkIf config.cli.docker.enable {
      virtualisation.docker.enable = true;
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };

      core.impermanence.hm.directories = [".local/share/docker"];
    };
  };
}
