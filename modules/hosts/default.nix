{
  lib,
  config,
  ...
}: {
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options.settings = lib.mkOption {
        type = lib.types.deferredModule;
        description = "The settings module for this host.";
      };
      options.hardware = lib.mkOption {
        type = lib.types.deferredModule;
        description = "The hardware module for this host.";
      };
    });
    default = {};
    description = "NixOS hosts.";
  };

  config.flake.nixosConfigurations = lib.flip lib.mapAttrs config.hosts (_: host:
    lib.nixosSystem {
      modules = [
        host.settings
        host.hardware
        config.flake.nixosModules.default
      ];
    });
}
