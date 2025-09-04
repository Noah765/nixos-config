{
  lib,
  pkgs,
  config,
  ...
}: {
  options.cli.vcs = {
    enable = lib.mkEnableOption "Jujutsu, Git and the GitHub CLI";
    jj.enable = lib.mkEnableOption "Jujutsu" // {default = true;};
    git.enable = lib.mkEnableOption "Git" // {default = true;};
    gh.enable = lib.mkEnableOption "the GitHub CLI" // {default = true;};
  };

  config = lib.mkIf config.cli.vcs.enable {
    hm.programs = {
      jujutsu.enable = config.cli.vcs.jj.enable;
      jujutsu.settings = {
        user.name = "Noah765";
        user.email = "noland62007@gmail.com";
        ui = {
          default-command = "log";
          diff-formatter = "${lib.getExe pkgs.difftastic} --color always --sort-paths $left $right";
          pager = "less -FRX";
        };
      };
      git = {
        inherit (config.cli.vcs.git) enable;
        userName = "Noah765";
        userEmail = "noland62007@gmail.com";
        extraConfig.init.defaultBranch = "main";
        difftastic.enable = true;
      };
      gh.enable = config.cli.vcs.gh.enable;
    };
    core.impermanence.hm.files = lib.mkIf config.cli.vcs.gh.enable [".config/gh/hosts.yml"];
  };
}
