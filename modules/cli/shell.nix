{
  self,
  lib,
  wlib,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.shell.enable = lib.mkEnableOption "nushell";

    config = lib.mkIf config.cli.shell.enable {
      wrappers.shell.enable = true;
      users.defaultUserShell = self.wrappers.shell.wrap {inherit pkgs;};

      environment.systemPackages = [pkgs.carapace];

      core.impermanence.hm.files = [
        ".local/share/nushell/history.sqlite3"
        ".local/share/nushell/history.sqlite3-shm"
        ".local/share/nushell/history.sqlite3-wal"
      ];
    };
  };

  flake.wrappers.shell = {pkgs, ...}: {
    imports = [wlib.wrapperModules.nushell];

    "config.nu".content = ''
      # Banner
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

      # Settings
      $env.config.history.file_format = 'sqlite'
      $env.config.history.isolation = true
      $env.config.history.path = $'($nu.home-dir)/.local/share/nushell/'
      $env.config.show_banner = false
      $env.config.recursion_limit = 1000
      $env.config.auto_cd_implicit = true
      $env.config.edit_mode = 'vi'
      $env.config.cursor_shape.vi_insert = 'line'
      $env.config.cursor_shape.vi_normal = 'block'
      $env.config.completions.algorithm = 'fuzzy'
      $env.config.use_kitty_protocol = true
      $env.config.display_errors.termination_signal = false
      $env.config.footer_mode = 'auto'
      $env.config.table.missing_value_symbol = ''
      $env.config.color_config.search_result = 'blue'

      # Aliases
      alias man = if (which batman | is-empty) { man } else { batman }
      alias l = if (which eza | is-empty) { ls --all } else { eza }
      alias ll = if (which eza | is-empty) { ls --all --long } else { eza --long }
      alias lt = if (which eza | is-not-empty) { eza --tree }

      # Hooks
      $env.config.hooks.env_change.PWD = [{||
        if (which direnv | is-empty) { return }
        direnv export json | from json | default {} | reject --optional --ignore-case shell | load-env
        $env.PATH = $env.PATH | split row : | path expand --no-symlink
      }]
      $env.config.hooks.display_output = {
        let value = $in
        if ($value | describe) in [int float bool range closure cell-path] {
          return ($value | to nuon --serialize | str trim --char '"' | str replace --all '\"' '"' | nu-highlight)
        }
        if (term size).columns >= 100 { $value | table --expand --expand-deep 5 } else { $value | table }
      }

      # Keybindings
      $env.config.keybindings ++= [
        {
          name: completion_menu
          modifier: control
          keycode: char_x
          mode: [vi_normal vi_insert]
          event: {
            send: menu
            name: completion_menu
          }
        }
        {
          name: help_menu
          modifier: control
          keycode: char_h
          mode: [vi_normal vi_insert]
          event: {
            send: executehostcommand
            cmd: ([
              fzf
              --disabled
              --ansi
              --preview='$env.config.use_ansi_coloring = true; help commands {}'
              r#'--bind='start:reload(help commands | get name | str join "\n")'''#
              r#'--bind='change:reload($env.config.color_config.search_result = "blue"; help commands --find {q} | get name | str join "\n")'''#
            ] | str join ' ')
          }
        }
        {
          name: zellij_sessionizer
          modifier: control
          keycode: char_s
          mode: [vi_normal vi_insert]
          event: {
            send: executehostcommand
            cmd: zellij-sessionizer
          }
        }
      ]

      # Menus
      $env.config.menus ++= [{
        name: completion_menu
        only_buffer_difference: false
        marker: ""
        type: { layout: columnar }
        style: {
          text: green
          selected_text: green_reverse
          description_text: dark_gray
        }
      }]

      # Prompt
      $env.PROMPT_COMMAND = {
        let path = $env.PWD | str replace $nu.home-dir ~

        let in_repo = pwd --physical | path split | generate {|x acc=[]| {out: ($acc | path join $x) next: ($acc ++ [$x])}} | any { ($in + /.jj | path type) == dir }
        let vcs = if (which jj | is-empty) or not $in_repo {
          ""
        } else {
          jj log --ignore-working-copy --color always --revisions @ --no-graph --template "replace('\n', builtin_log_compact, |_| ' ')"
          | str replace --all (ansi attr_bold) ""
        }

        let prompt_indicator = if $env.LAST_EXIT_CODE == 0 { $'(ansi cyan)❯(ansi reset)' } else { $'(ansi red)❯(ansi reset)' }

        $"\n($path)(if $vcs != "" { ' ' + $vcs })\n($prompt_indicator) "
      }
      $env.PROMPT_COMMAND_RIGHT = {
        let duration = $env.CMD_DURATION_MS | into duration --unit ms
        if $duration > 5sec { $duration }
      }
      $env.PROMPT_INDICATOR_VI_NORMAL = ""
      $env.PROMPT_INDICATOR_VI_INSERT = ""
      $env.PROMPT_MULTILINE_INDICATOR = '  '
      $env.TRANSIENT_PROMPT_COMMAND = { $env.PWD | str replace $nu.home-dir ~ | $'($in)❯ ' }
      $env.TRANSIENT_PROMPT_COMMAND_RIGHT = $env.PROMPT_COMMAND_RIGHT;

      # Completions
      $env.CARAPACE_LENIENT = 1
      $env.CARAPACE_MATCH = 1
      source ${pkgs.runCommandLocal "carapace.nu" {} "${lib.getExe pkgs.carapace} _carapace nushell > \"$out\""}

      # cd
      source ${pkgs.runCommandLocal "zoxide.nu" {} "${lib.getExe pkgs.zoxide} init --no-cmd nushell > \"$out\""}
      def "nu-complete zoxide path" [context: string] {
        let parts = $context | str trim --left | split row ' ' | skip | str downcase
        {
          options: {
            sort: false
            case_sensitive: false
            completion_algorithm: substring
          }
          completions: (zoxide query --list --exclude $env.PWD -- ...$parts | lines | each {|result|
            if ($parts | length) <= 1 { return $result }
            let suffix_length = $parts | drop | reduce --fold ($result | str downcase) {|x| split row --number 2 $x | get 1 } | str length
            { value: ($result | str substring (0 - $suffix_length)..) description: $result }
          })
        }
      }
      def --env --wrapped z [...rest: string@"nu-complete zoxide path"] { if (which zoxide | is-empty) { cd ($rest | first) } else { __zoxide_z ...$rest } }
      alias cd = z
      alias cdi = __zoxide_zi

      # File manager
      def --env y [...args] {
        let tmp = mktemp --tmpdir yazi-cwd.XXXXXX
        yazi ...$args --cwd-file $tmp
        let cwd = open $tmp
        if $cwd != $env.PWD and ($cwd | path exists) { cd $cwd }
        rm $tmp
      }

      # fzf
      let display = '--height 50% --popup 75%'
      let file_preview = if (which bat | is-empty) { 'open {}' } else { 'bat --force-colorization --style=default,-header {}' }
      let dir_preview = if (which eza | is-empty) { 'ls {}' } else { 'eza --tree --color always --level 2 {}' }
      $env.FZF_CTRL_T_COMMAND = 'fd';
      $env.FZF_CTRL_T_OPTS = $"($display) --preview='if \({} | path type\) == dir { ($dir_preview) } else { ($file_preview) }'";
      $env.FZF_ALT_C_COMMAND = "fd --type directory";
      $env.FZF_ALT_C_OPTS = $"($display) --preview '($dir_preview)'";
      source ${pkgs.runCommandLocal "fzf.nu" {} "${lib.getExe pkgs.fzf} --nushell > \"$out\""}
    '';
  };
}
