{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.documentation;
in {
  options.documentation.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to install documentation for Combined Manager, NixOS and Home Manager options.";
  };

  config.os.documentation = mkIf cfg.enable {
    # TODO
    # dev.enable = true;
    # nixos.includeAllModules = true;
  };
}
