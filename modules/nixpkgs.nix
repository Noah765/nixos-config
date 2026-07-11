{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    system,
    config,
    ...
  }: {
    options.nixpkgs.overlays = lib.mkOption {
      type = lib.types.listOf (lib.mkOptionType {
        name = "nixpkgs-overlay";
        description = "nixpkgs overlay";
        check = lib.isFunction;
        merge = lib.mergeOneOption;
      });
      default = [];
      description = "Overlays to apply to Nixpkgs.";
    };

    config._module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      inherit (config.nixpkgs) overlays;
    };
  };
}
