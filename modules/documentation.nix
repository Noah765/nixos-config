{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption;
  cfg = config.documentation;
in {
  options.documentation.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to install documentation for Modulix, NixOS and Home Manager options.";
  };

  config.os.documentation = mkIf cfg.enable {
    # TODO
    # dev.enable = true;
    # nixos.includeAllModules = true;
  };
}
