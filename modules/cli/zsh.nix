{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.cli.zsh;
in {
  options.cli.zsh.enable = mkEnableOption "Zsh";

  config = mkIf cfg.enable {
    os = {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
      environment.pathsToLink = ["/share/zsh"];
    };
    hm.programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.path = mkIf config.impermanence.enable "/persist/home/.zsh_history"; # The file can get replaced by zsh, which breaks symlinks, so the normal impermanence module won't work here
    };
  };
}
