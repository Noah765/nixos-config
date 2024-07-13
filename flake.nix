let
  # TODO Put combined manager itself as a flake input for automatic updating?
  #combinedManager = builtins.getFlake "github:Noah765/combined-manager/0a7e9f622295f09d48f82d65dfc5300bcfaebe1f";
  combinedManager = import /home/noah/Downloads/combined-manager;
in
combinedManager.mkFlake {
  description = "NixOS configuration";
  lockFile = ./flake.lock;
  stateVersion = "24.11";

  configurations = {
    primary.modules = [
      ./modules
      ./hosts/primary/configuration.nix
    ];

    iso = {
      useHomeManager = false;
      modules = [
        ./modules
        ./hosts/iso/configuration.nix
      ];
    };
  };
}
