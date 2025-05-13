{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) getExe literalExpression mkEnableOption mkIf;
  cfg = config.cli.vcs;
  mkEnableOptionWithDefault = name:
    mkEnableOption name
    // {
      default = cfg.enable;
      defaultText = literalExpression "config.cli.vcs.enable";
    };
in {
  options.cli.vcs = {
    enable = mkEnableOption "Jujutsu, Git and the GitHub CLI";
    jj.enable = mkEnableOptionWithDefault "Jujutsu";
    git.enable = mkEnableOptionWithDefault "Git";
    gh.enable = mkEnableOptionWithDefault "the GitHub CLI";
  };

  config = mkIf cfg.enable {
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
