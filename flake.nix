let
  # TODO Put combined manager itself as a flake input for automatic updating?
  combinedManager = builtins.getFlake "github:Noah765/combined-manager/dcafe5ffd31701861d3a7933d068f55edfe842bd";
in
combinedManager.mkFlake {
  description = "NixOS configuration";
  lockFile = ./flake.lock;
  system = "x86_64-linux";

  configurations = {
    primary.modules = [
      ./modules
      ./hosts/primary/configuration.nix
    ];
  };
}
