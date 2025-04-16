{
  lib,
  options,
  config,
  ...
}: let
  inherit (lib) concatMap concatStringsSep drop flip getAttrFromPath mkOption removeSuffix splitString;
  inherit (lib.types) listOf str;
in {
  options.dependencies = mkOption {
    type = listOf str;
    internal = true;
    default = [];
    description = "Allows modules to express dependencies that must be enabled for the module to work properly. If the dependencies are not enabled, an error is thrown.";
  };

  config.assertions = flip concatMap options.dependencies.definitionsWithLocations (
    x: let
      dependent = removeSuffix ".nix" (concatStringsSep "." (drop 5 (splitString "/" x.file)));
    in
      flip map x.value (x: {
        assertion = getAttrFromPath (splitString "." x ++ ["enable"]) config;
        message = "${dependent} depends on ${x}, but ${x} is disabled.";
      })
  );
}
