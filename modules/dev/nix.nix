{lib, ...}: {
  debug = true;

  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.dev.nix.enable = lib.mkEnableOption "Nix development tools";

    config.cli.editor = lib.mkIf config.dev.nix.enable {
      packages = [pkgs.nixd];
      languageServers.nixd.config.nixd.options = {
        flake-parts.expr = "(builtins.getFlake \"/etc/nixos\").debug.options";
        flake-parts-per-system.expr = "(builtins.getFlake \"/etc/nixos\").currentSystem.options";
        nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.primary.options";
        home-manager.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.primary.options.home-manager.users.type.getSubOptions []";
      };
    };
  };
}
