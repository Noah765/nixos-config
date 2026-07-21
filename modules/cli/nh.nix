{lib, ...}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "nh" "enable"] ["wrappers" "nh" "enable"])];

  flake.wrappers.nh.imports = [lib.w.wrapperModules.nh];
}
