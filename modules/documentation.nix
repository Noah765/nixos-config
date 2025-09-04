{
  lib,
  config,
  ...
}: {
  options.documentation.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to install documentation for Modulix, NixOS and Home Manager options.";
  };

  config.os.documentation = lib.mkIf config.documentation.enable {
    # TODO
    # dev.enable = true;
    # nixos.includeAllModules = true;
  };
}
