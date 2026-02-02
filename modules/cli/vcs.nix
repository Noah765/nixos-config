{
  lib,
  pkgs,
  config,
  ...
}: {
  options.cli.vcs = {
    enable = lib.mkEnableOption "Jujutsu, Jujutsu UI, Git and the GitHub CLI";
    jj.enable = lib.mkEnableOption "Jujutsu" // {default = true;};
    jjui.enable = lib.mkEnableOption "Jujutsu UI" // {default = true;};
    git.enable = lib.mkEnableOption "Git" // {default = true;};
    gh.enable = lib.mkEnableOption "the GitHub CLI" // {default = true;};
  };

  config = lib.mkIf config.cli.vcs.enable {
    hm.programs = {
      jujutsu.enable = config.cli.vcs.jj.enable;

      jujutsu.settings = {
        user.name = "Noah765";
        user.email = "noah.landgraf@gmx.de";

        ui = {
          default-command = "log";
          diff-formatter = "${lib.getExe pkgs.difftastic} --color always --sort-paths $left $right";
          movement.edit = true;
          log-word-wrap = true;
        };

        # TODO diff editor and merge tool

        fix.tools.treefmt.command = ["treefmt" "--quiet" "--stdin" "$path"];
        fix.tools.treefmt.patterns = ["**"];

        remotes.origin.auto-track-bookmarks = "*";
        remotes.upstream.auto-track-bookmarks = "main|master";

        fsmonitor.backend = "watchman";

        aliases = lib.mapAttrs (name: script: ["util" "exec" "--" (pkgs.writers.writeNu "jj-${name}" script)]) {
          push = ''
            def main [--revision (-r) = '@'] {
              jj bookmark move main -t $revision
              jj git push
            }
          '';

          gh = ''
            def main [name: string --private (-p)] {
              ${lib.getExe pkgs.gh} repo create $name (if $private { '--private' } else { '--public' })
              jj git clone $'https://github.com/Noah765/($name)'
              cd $name
              jj describe -m init
              jj bookmark create main
            }
          '';

          fork = ''
            def main [owner: string repo: string] {
              ${lib.getExe pkgs.gh} repo fork $'($owner)/($repo)' --clone=false --default-branch-only
              main clone $repo --owner $owner
            }

            def "main clone" [repo: string --owner: string] {
              jj git clone $'https://github.com/Noah765/($repo)'
              cd $repo
              let owner = if $owner != null { $owner } else { ${lib.getExe pkgs.gh} repo view $repo --json parent --jq .parent.owner.login }
              jj git remote add upstream $'https://github.com/($owner)/($repo)'
              jj config set --repo git.fetch '["origin", "upstream"]'
              jj git fetch
            }
          '';
        };
      };

      difftastic.enable = true;
      difftastic.git.enable = true;

      jjui.enable = config.cli.vcs.jjui.enable;
      jjui.settings = {
        ui.tracer.enabled = true;
        suggest.exec.mode = "fuzzy";
        preview.show_at_start = true;
      };

      git.enable = config.cli.vcs.git.enable;
      git.settings = {
        user.name = "Noah765";
        user.email = "noah.landgraf@gmx.de";
        init.defaultBranch = "main";
      };

      gh.enable = config.cli.vcs.gh.enable;
    };

    hm.home.packages = [pkgs.watchman];

    cli.editor.languages.jjdescription.language-servers = ["harper-ls" "codebook"];
    cli.editor.languages.git-commit.language-servers = ["harper-ls" "codebook"];

    core.impermanence.hm.files = lib.mkIf config.cli.vcs.gh.enable [".config/gh/hosts.yml"];
  };
}
