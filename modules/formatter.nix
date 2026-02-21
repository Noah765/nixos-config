{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem.treefmt.programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    qmlformat.enable = true;
    statix.enable = true;
  };

  perSystem.treefmt.settings.formatter.qmlformat.options = ["--indent-width=2" "--sort-imports" "--semicolon-rule=essential"];
}
