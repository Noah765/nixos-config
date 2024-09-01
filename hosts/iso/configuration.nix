{pkgs, ...}: {
  osImports = [
    ({modulesPath, ...}: {
      imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
      nixpkgs.hostPlatform.system = "x86_64-linux";
    })
  ];

  hmUsername = "nixos";

  core = {
    impermanence.enable = false;
    networkmanager.hostName = "nixos";
    user.enable = false;
  };

  desktop.enable = false;

  os = {
    isoImage.makeBiosBootable = false; # Make sure the firmware for an EFI install is available

    # Make sure that the install script doesn't exceed the file descriptor limit
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = 4096;
      }
    ];
  };

  hm.home.packages = with pkgs; [
    (import ./wifi-script.nix pkgs)
    (import ./download-script.nix pkgs)
    (import ./generate-script.nix pkgs)
    (import ./install-script.nix pkgs)
    # TODO Provide these in separate modules
    fzf
    disko
  ];
}
