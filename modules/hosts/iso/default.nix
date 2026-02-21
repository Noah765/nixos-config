{moduleWithSystem, ...}: {
  hosts.iso.settings = moduleWithSystem ({config, ...}: {pkgs, ...}: {
    core = {
      impermanence.enable = false;
      networkmanager.hostName = "nixos";
      user.enable = false;
    };

    desktop.enable = false;

    hm.home.packages = with config.packages; [
      wifi
      download
      generate
      install-os
      # TODO Provide these in separate modules
      pkgs.fzf
      pkgs.disko
    ];
  });

  hosts.iso.hardware = {modulesPath, ...}: {
    imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];

    isoImage.makeBiosBootable = false;

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = 4096;
      }
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
