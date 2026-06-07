{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.cd.enable = lib.mkEnableOption "zoxide";

    config = lib.mkIf config.cli.cd.enable {
      environment.systemPackages = [pkgs.zoxide];
      core.impermanence.hm.directories = [".local/share/zoxide"];
    };
  };
}
