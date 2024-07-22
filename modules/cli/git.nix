{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.cli.git;
in {
  options.cli.git = {
    enable = mkEnableOption "Git";
    gitHub = mkEnableOption "the GitHub CLI";
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

    core.impermanence.hm.files = mkIf cfg.gitHub [".config/gh/hosts.yml"];
  };
}
