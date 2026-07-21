{lib, ...}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "git" "enable"] ["wrappers" "git" "enable"])];

  flake.wrappers.git.imports = [lib.w.wrapperModules.git];
  flake.wrappers.git.settings = {
    user.name = "Noah765";
    user.email = "noah.landgraf@gmx.de";
    credential."https://github.com".helper = "!gh auth git-credential";
    credential."https://gist.github.com".helper = "!gh auth git-credential";
  };
}
