{
  lib,
  pkgs,
  config,
  ...
}: {
  options.cli.nushell.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf config.cli.nushell.enable {
    dependencies = ["cli.vcs"];

    os.users.defaultUserShell = pkgs.nushell;

    core.impermanence.hm.files = [".config/nushell/history.sqlite3"];

    hm.programs = {
      nushell = {
        enable = true;

        # TODO https://github.com/nix-community/home-manager/issues/4313
        environmentVariables =
          lib.filterAttrs (_: x: !lib.isString x || !lib.hasInfix "\${" x) config.hm.home.sessionVariables
          // rec {
            PROMPT_COMMAND = lib.hm.nushell.mkNushellInline ''
              {
                let path = $env.PWD | str replace $nu.home-path '~'

                let in_repo = 0..<($env.PWD | path split | length) | each {|x| $env.PWD | path dirname -n $x } | any { ($in + '/.jj' | path type) == 'dir' }
                let vcs = if not $in_repo {
                  ""
                } else {
                  ${lib.getExe pkgs.jujutsu} log --revisions '@' --no-graph --ignore-working-copy --color always --template r#'
                    separate(' ',
                      format_short_change_id_with_hidden_and_divergent_info(self),
                      format_short_commit_id(commit_id),
                      bookmarks,
                      tags,
                      working_copies,
                      if(conflict, label('conflict', 'conflict')),

                      if(empty, empty_commit_marker),
                      if(description,
                        description.first_line(),
                        label(if(empty, 'empty'), description_placeholder),
                      ),
                    )
                  '#
                }

                let prompt_indicator = if $env.LAST_EXIT_CODE == 0 { $'(ansi cyan)❯(ansi reset)' } else { $'(ansi red)❯(ansi reset)' }

                $"\n($path)(if $in_repo { ' ' + $vcs })\n($prompt_indicator)"
              }
            '';
            TRANSIENT_PROMPT_COMMAND = lib.hm.nushell.mkNushellInline "{ $env.PWD | str replace $nu.home-path '~' | $in + '❯' }";
            PROMPT_COMMAND_RIGHT = lib.hm.nushell.mkNushellInline "{ let duration = $env.CMD_DURATION_MS | into duration --unit 'ms'; if $duration > 5sec { $duration } }";
            TRANSITIVE_PROMPT_COMMAND_RIGHT = PROMPT_COMMAND_RIGHT;

            PROMPT_INDICATOR_VI_NORMAL = lib.hm.nushell.mkNushellInline "{ if $env.LAST_EXIT_CODE == 0 { ':' } else { $'(ansi red):(ansi reset)' } }";
            PROMPT_INDICATOR_VI_INSERT = " ";
            PROMPT_MULTILINE_INDICATOR = ": ";
          };

        extraConfig = ''
          if $nu.is-interactive {
            let ellie = [
              '     __  ,'
              " .--()°'.'"
              "'|, . ,'  "
              ' !_-(_\   '
            ]
            let memory = sys mem
            let disk = sys disks | first
            print $'(ansi green)($ellie.0)'
            print $'(ansi green)($ellie.1)  (ansi yellow) (ansi yellow_bold)Nushell (ansi reset)(ansi yellow)v(version | get version)'
            print $'(ansi green)($ellie.2)  (ansi blue) (ansi blue_bold)Disk (ansi reset)(ansi blue)($disk.total - $disk.free) / ($disk.total)'
            print $"(ansi green)($ellie.3)  (ansi purple)󰍛 (ansi purple_bold)RAM (ansi reset)(ansi purple)($memory.used) / ($memory.total)(ansi reset)\n"
          }
        '';

        settings = {
          history.file_format = "sqlite";
          history.isolation = true;
          show_banner = false;
          edit_mode = "vi";
          cursor_shape.vi_insert = "line";
          cursor_shape.vi_normal = "block";
          completions.algorithm = "fuzzy";
          use_kitty_protocol = config.apps.terminal.enable;
          display_errors.termination_signal = false;
          footer_mode = "auto";
          table.footer_inheritance = true;
          table.missing_value_symbol = "❌";
          filesize.precision = 3;
          float_precision = 3;
          hooks.display_output = lib.hm.nushell.mkNushellInline ''
            {
              let value = $in
              if ($value | describe) in ['int' 'float' 'bool' 'range' 'closure' 'cell-path'] {
                return ($value | to nuon --serialize | str trim --char '"' | str replace --all '\"' '"' | nu-highlight)
              }
              if (term size).columns >= 100 { $value | table --expand --expand-deep 5 } else { $value | table }
            }
          '';
          # TODO Integrate fzf
          keybindings = lib.map (x:
            {
              modifier = "control";
              mode = ["vi_normal" "vi_insert"];
            }
            // x) [
            {
              name = "completion_menu";
              keycode = "char_x";
              event.send = "menu";
              event.name = "completion_menu";
            }
            {
              name = "help_menu";
              keycode = "char_?";
              event.send = "menu";
              event.name = "help_menu";
            }
            {
              name = "menu_next";
              keycode = "char_n";
              event.send = "MenuNext";
            }
            {
              name = "menu_previous";
              keycode = "char_p";
              event.send = "MenuPrevious";
            }
            {
              name = "menu_right";
              keycode = "char_f";
              event.send = "MenuRight";
            }
            {
              name = "menu_left";
              keycode = "char_b";
              event.send = "MenuLeft";
            }
            {
              name = "menu_forward";
              keycode = "char_d";
              event.send = "MenuPageNext";
            }
            {
              name = "menu_backward";
              keycode = "char_u";
              event.send = "MenuPagePrevious";
            }
          ];
        };
      };

      carapace.enable = true;
    };
  };
}
