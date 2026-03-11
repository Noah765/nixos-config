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
      qmlformat.enable = true;
      statix.enable = true;
    };
    treefmt.settings.formatter = {
      nestix.command = lib.getExe inputs'.nestix.packages.default;
      nestix.includes = ["*.nix"];
      qmlformat.options = ["--indent-width=2" "--sort-imports" "--semicolon-rule=essential"];
    };
  };
}
