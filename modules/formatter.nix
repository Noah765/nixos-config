{
  lib,
  inputs,
  ...
}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {inputs', ...}: {
    treefmt.programs = {
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
    treefmt.settings.formatter.nestix = {
      command = lib.getExe inputs'.nestix.packages.default;
      includes = ["*.nix"];
    };
  };
}
