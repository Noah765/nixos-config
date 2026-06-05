{
  lib,
  wlib,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "fd" "enable"] ["wrappers" "fd" "enable"])];

  flake.wrappers.fd = {pkgs, ...}: {
    imports = [wlib.modules.default];
    package = pkgs.fd;
    addFlag = ["--hidden" "--exclude=.git" "--exclude=.jj"];
  };
}
