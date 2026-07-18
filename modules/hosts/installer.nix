{
  hosts.installer.settings = {pkgs, ...}: {
    core = {
      impermanence.enable = false;
      networking.hostName = "installer";
      user.enable = false;
    };

    desktop.enable = false;

    hm.home.packages = [pkgs.disko];
  };

  hosts.installer.hardware = {modulesPath, ...}: {
    imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
