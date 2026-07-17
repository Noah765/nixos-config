{
  hosts.iso.settings = {pkgs, ...}: {
    core = {
      impermanence.enable = false;
      networking.hostName = "nixos";
      user.enable = false;
    };

    desktop.enable = false;

    hm.home.packages = [pkgs.disko];
  };

  hosts.iso.hardware = {modulesPath, ...}: {
    imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
