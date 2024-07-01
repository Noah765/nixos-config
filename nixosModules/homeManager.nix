{
  inputs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.homeManager;
in
{
  imports = [ inputs.home-manager.nixosModules.default ];

  options.homeManager = {
    enable = mkEnableOption "home manager";
    module = mkOption {
      type = types.path;
      example = ./home.nix;
      description = "The configuration home manager module to import. `inputs.self.outputs.homeManagerModules.default` is imported automatically as well.";
    };
  };

  config.home-manager = mkIf cfg.enable {
    useGlobalPkgs = true;
    extraSpecialArgs.inputs = inputs;
    users.noah = {
      imports = [
        cfg.module
        inputs.self.outputs.homeManagerModules.default
      ];
    };
  };
}
