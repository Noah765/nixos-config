{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.nix-output-monitor.enable = lib.mkEnableOption "nix-output-monitor";

    config.environment.systemPackages = lib.mkIf config.cli.nix-output-monitor.enable [pkgs.nix-output-monitor];
  };
}
