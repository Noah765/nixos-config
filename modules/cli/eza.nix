{
  lib,
  wlib,
  ...
}: {
  nixos = {config, ...}: {
    options.cli.eza.enable = lib.mkEnableOption "eza";

    config = lib.mkIf config.cli.eza.enable {
      wrappers.eza.enable = true;

      cli.nushell.shellAliases = {
        l = lib.mkIf config.cli.eza.enable "eza";
        ll = lib.mkIf config.cli.eza.enable "eza --long";
        lt = lib.mkIf config.cli.eza.enable "eza --tree";
      };
    };
  };

  flake.wrappers.eza = {pkgs, ...}: {
    imports = [wlib.modules.default];

    package = pkgs.eza;

    addFlag = [
      "--across"
      "--icons"
      "--all"
      "--ignore-glob=.jj"
      "--git-ignore"
      "--group-directories-first"
      "--group"
      "--git"
    ];
  };
}
