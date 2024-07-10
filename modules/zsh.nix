{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.zsh;
in
{
  options.zsh.enable = mkEnableOption "zsh";

  config.os = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
