{
  self,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.wrappers.flakeModules.default];

  _module.args.wlib = inputs.wrappers.lib;

  nixos.imports = lib.mapAttrsToList (_: v: v.install) self.wrappers;
}
