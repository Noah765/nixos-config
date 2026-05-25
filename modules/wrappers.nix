{
  self,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.wrappers.flakeModules.default];
  nixos.imports = lib.mapAttrsToList (_: v: v.install) self.wrappers;
}
