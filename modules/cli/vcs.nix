{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) getExe mkDefault mkEnableOption mkIf;
  cfg = config.cli.vcs;
in {
  options.cli.vcs = {
    enable = mkEnableOption "Jujutsu, Git and the GitHub CLI";
    jj.enable = mkEnableOption "Jujutsu";
    git.enable = mkEnableOption "Git";
    gh.enable = mkEnableOption "the GitHub CLI";
  };

  config = {
    cli.vcs = mkIf cfg.enable {
      jj.enable = mkDefault true;
      git.enable = mkDefault true;
      gh.enable = mkDefault true;
    };

    hm.programs = {
      jujutsu.enable = cfg.jj.enable;
      jujutsu.settings = {
        user.name = "Noah765";
        user.email = "noland62007@gmail.com";
        ui = {
          default-command = "log";
          diff.tool = "${getExe pkgs.difftastic} --color always --sort-paths $left $right";
          pager = "less -FRX";
        };
      };
      git = {
        inherit (cfg.git) enable;
        userName = "Noah765";
        userEmail = "noland62007@gmail.com";
        extraConfig.init.defaultBranch = "main";
        difftastic.enable = true;
      };
      gh.enable = cfg.gh.enable;
    };
    core.impermanence.hm.files = mkIf cfg.gh.enable [".config/gh/hosts.yml"];
  };
}
