{
  perSystem = {
    pkgs,
    config,
    ...
  }: {devShells.default = pkgs.mkShellNoCC {packages = [pkgs.quickshell config.treefmt.build.wrapper];};};
}
