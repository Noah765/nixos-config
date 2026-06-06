{
  lib,
  wlib,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "bat" "enable"] ["wrappers" "bat" "enable"])];

  flake.wrappers.bat = {pkgs, ...}: {
    imports = [wlib.modules.default];
    package = pkgs.bat;
    flags."--theme" = "base16";
  };
}
