{lib, ...}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "fd" "enable"] ["wrappers" "fd" "enable"])];

  flake.wrappers.fd = {pkgs, ...}: {
    imports = [lib.w.modules.default];
    package = pkgs.fd;
    addFlag = ["--hidden" "--exclude=.git" "--exclude=.jj"];
  };
}
