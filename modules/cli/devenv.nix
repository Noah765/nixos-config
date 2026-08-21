{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.devenv.enable = lib.mkEnableOption "devenv";

    config = lib.mkIf config.cli.direnv.enable {
      environment.systemPackages = [pkgs.devenv];
      core.impermanence.hm.directories = [".local/share/devenv"];
      core.cleanup.script = ''
        cd /home/noah
        ${lib.getExe pkgs.devenv} gc
      '';
    };
  };
}
