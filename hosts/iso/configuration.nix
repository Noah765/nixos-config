{
  pkgs,
  config,
  ...
}: {
  osImports = [
    (
      {modulesPath, ...}: {
        imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
      }
    )
  ];

  impermanence.enable = false;
  user.enable = false;

  os = {
    nixpkgs.hostPlatform = "x86_64-linux"; # TODO Required?
    isoImage.makeBiosBootable = false; # Make sure the firmware for an EFI install is available

    environment.systemPackages = with pkgs; [
      (./wifiScript.nix pkgs)
      (./downloadScript.nix pkgs)
      (./generateScript.nix pkgs)
      (./installScript.nix pkgs)
      git
      disko
      neovim
      fzf
      nixfmt-rfc-style
    ];
  };
}
