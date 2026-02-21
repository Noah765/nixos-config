{
  initialInputs.treefmt.url = "github:numtide/treefmt-nix";
  initialInputs.treefmt.inputs.nixpkgs.follows = "nixpkgs";
  initialInputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

  defaultHmUsername = "noah";

  globalModules = [./modules];

  configurations = {
    primary.modules = [hosts/primary];
    laptop.modules = [./hosts/laptop];
    iso.modules = [./hosts/iso];
  };

  outputs = {
    nixpkgs,
    treefmt,
    ...
  }: let
    eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (x: f nixpkgs.legacyPackages.${x});

    formatter = pkgs:
      (treefmt.lib.evalModule pkgs {
        programs = {
          alejandra.enable = true;
          deadnix.enable = true;
          qmlformat.enable = true;
          statix.enable = true;
        };

        settings.formatter.qmlformat.options = ["--indent-width=2" "--sort-imports" "--semicolon-rule=essential"];
      }).config.build.wrapper;
  in {
    devShells = eachSystem (pkgs: {default = pkgs.mkShell {packages = [pkgs.quickshell (formatter pkgs)];};});

    formatter = eachSystem formatter;
  };
}
