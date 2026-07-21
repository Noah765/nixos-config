{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.nom.enable = lib.mkEnableOption "nix-output-monitor";

    config.environment.systemPackages = lib.mkIf config.cli.nom.enable [pkgs.nix-output-monitor];
  };
}
