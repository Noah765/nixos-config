{
  osConfig,
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

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.zsh.enable;
        message = "The NixOS zsh module is required for the home manager zsh module.";
      }
    ];

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.path = mkIf config.impermanence.enable "/persist/home/.zsh_history"; # The file can get replaced by zsh, which breaks symlinks, so the normal impermanence module doesn't work here
    };
  };
}
