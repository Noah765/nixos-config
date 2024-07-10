{ lib, config, ... }:
with lib;
let
  cfg = config.git;
in
{
  options.git = {
    enable = mkEnableOption "git";
    gitHub = mkEnableOption "GitHub CLI";
  };

  config = mkIf cfg.enable {
    hm.programs = {
      git = {
        enable = true;
        userName = "Noah765";
        userEmail = "noland62007@gmail.com";
      };

      gh.enable = mkIf cfg.gitHub true;
    };
    impermanence.hm.files = mkIf cfg.gitHub [ ".config/gh/hosts.yml" ];
  };
}
