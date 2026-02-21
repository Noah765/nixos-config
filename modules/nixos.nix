{
  lib,
  inputs,
  ...
}: {
  imports = [(lib.mkAliasOptionModule ["nixos"] ["flake" "nixosModules" "default"])];

  nixos = {config, ...}: {
    imports = [
      inputs.home-manager.nixosModules.default
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" "noah"])
    ];

    _module.args.hmLib = config.home-manager.users.noah.lib;

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;

    apps.enable = lib.mkIf config.desktop.enable (lib.mkDefault true);
    cli.enable = lib.mkDefault true;
    core.enable = lib.mkDefault true;
    desktop.enable = lib.mkDefault true;
    dev.enable = lib.mkDefault true;
  };
}
