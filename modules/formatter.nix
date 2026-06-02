{
  lib,
  inputs,
  ...
}: {
  imports = [inputs.treefmt.flakeModule];

  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    treefmt.programs = {
      alejandra.enable = true;
      deadnix.enable = true;
      deadnix.no-lambda-pattern-names = true;
      statix.enable = true;
    };
    treefmt.settings.formatter = {
      nestix.command = lib.getExe inputs'.nestix.packages.default;
      nestix.includes = ["*.nix"];

      trim-codebook.command = pkgs.writers.writeNuBin "trim-codebook" ''
        def main [...files: string] {
          idx init --wait .

          for x in $files {
            let input = open $x | get words
            let output = $input | where {|x| idx search $x | where path != codebook.toml | is-not-empty }
            if ($input | length) != ($output | length) { {words: $output} | save -f $x }
          }
        }
      '';
      trim-codebook.includes = ["codebook.toml"];
    };
  };
}
