{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.gh.enable = lib.mkEnableOption "the GitHub CLI";

    config = lib.mkIf config.cli.gh.enable {
      environment.systemPackages = [pkgs.gh];
      core.impermanence.hm.files = [".config/gh/hosts.yml"];
    };
  };
}
