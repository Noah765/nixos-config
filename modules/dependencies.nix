{
  lib,
  options,
  config,
  ...
}:
with lib; {
  options.dependencies = mkOption {
    type = with types; listOf str;
    internal = true;
    default = [];
    description = "Allows modules to express dependencies that must be enabled for the module to work properly. If the dependencies are not enabled, an error is thrown.";
  };

  config.assertions = foldl (assertions: {
    file,
    value,
  }: let
    dependent = removeSuffix ".nix" (concatStringsSep "." (drop 5 (splitString "/" file)));
  in
    assertions
    ++ map (x: let
      path = strings.splitString "." x ++ ["enable"];
    in {
      assertion = attrsets.getAttrFromPath path config;
      message = "The ${dependent} module is dependent on the ${x} module.";
    })
    value) []
  options.dependencies.definitionsWithLocations;
}
