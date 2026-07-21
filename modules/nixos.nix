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

    system.stateVersion = "26.11";
    hm.home.stateVersion = "26.11";

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;

    apps.enable = lib.mkIf config.desktop.enable (lib.mkDefault true);
    cli.enable = lib.mkDefault true;
    core.enable = lib.mkDefault true;
    desktop.enable = lib.mkDefault true;
    dev.enable = lib.mkDefault true;
    theming.enable = lib.mkDefault true;
  };
}
