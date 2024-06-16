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
      example = "./home.nix";
    };
  };

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs.inputs = inputs;
      users.noah = {
        imports = [
          cfg.module
          inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
  };
}
