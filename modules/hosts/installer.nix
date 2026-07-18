{lib, ...}: {
  hosts.installer.settings = {pkgs, ...}: {
    core.impermanence.enable = false;
    core.networking.hostName = "installer";
    desktop.enable = false;

    users.users.nixos.enable = false;
    services.getty.autologinUser = lib.mkForce "noah";

    hm.home.packages = [pkgs.disko];
  };

  hosts.installer.hardware = {modulesPath, ...}: {
    imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
