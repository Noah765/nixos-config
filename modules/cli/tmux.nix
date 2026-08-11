{
  self,
  lib,
  getDefaultTheme,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.tmux.enable = lib.mkEnableOption "tmux";

    config = lib.mkIf config.cli.tmux.enable {
      wrappers.tmux.enable = true;
      environment.systemPackages = [pkgs.sesh self.packages.${pkgs.stdenv.system}.sesh-fzf];
    };
  };

  theme."tmux.conf".text = theme: _: ''
    # General
    set -g clock-mode-colour white
    set -g menu-border-style fg=${theme.inactiveBorder}
    set -g menu-selected-style bold,bg=${theme.selectedLine}
    set -g pane-active-border-style fg=${theme.activeBorder}
    set -g pane-border-style fg=${theme.inactiveBorder}
    set -g popup-border-style fg=${theme.activeBorder}

    # Copy mode
    set -g copy-mode-line-number-style fg=${theme.inactiveLineNumber}
    set -g copy-mode-current-line-number-style fg=${theme.activeLineNumber}
    set -g copy-mode-match-style fg=${theme.inactiveSearchFg},bg=${theme.inactiveSearchBg}
    set -g copy-mode-current-match-style fg=${theme.activeSearchFg},bg=${theme.activeSearchBg}
    set -g copy-mode-selection-style bg=${theme.selectionBg}
    set -g copy-mode-mark-style ""
    set -g copy-mode-position-style ""

    # Status
    set -g status-style bg=${theme.tabLineBg}
    set -g status-left '#[bold,fg=${theme.activeFg},bg=${theme.activeBg}] #{session_name} #{?#{&&:#{==:#{pane_mode},copy-mode},#{@select}},#[bg=default] #[bg=blue] SELECT }#[default,fg=${theme.inactiveFg}] #{s|#{HOME}|~:session_path}'
    set -g message-style width=30%,fill=${theme.tabLineBg},bg=${theme.tabLineBg}
    set -g window-status-style fg=${theme.inactiveFg},bg=${theme.inactiveBg}
    set -g window-status-current-style bold,fg=${theme.activeFg},bg=${theme.activeBg}
    set -g window-status-bell-style default

    # Plugins
    set -g @floax-border-color '${theme.activeBorder}'
    set -g @floax-text-color default
    run ${inputs.tmux-floax}/floax.tmux
    if 'tmux has-session -t scratch' { detach -s scratch }
  '';

  flake.wrappers.sesh = {
    pkgs,
    config,
    ...
  }: {
    imports = [lib.w.modules.default];

    package = pkgs.sesh;

    flags."--config" = config.constructFiles.config.path;

    constructFiles.config = {
      relPath = "${config.binName}-config.toml";
      builder = ''${lib.getExe' pkgs.remarshal "json2toml"} "$1" "$2"'';
      content = lib.toJSON {
        blacklist = ["scratch"];
        default_session.preview_command = "${lib.getExe pkgs.eza} --tree --color always --level 2 {}";
        session = lib.singleton {
          name = "NixOS";
          path = "/etc/nixos";
          startup_command = "hx";
        };
        wildcard = lib.singleton {
          pattern = "~/projects/*";
          startup_command = "hx";
        };
      };
    };
  };

  perSystem = {pkgs, ...}: {
    packages.sesh-fzf = pkgs.writers.writeNuBin "sesh-fzf" ''
      ${lib.getExe pkgs.sesh} list --hide-duplicates --icons
      | try {
        (${lib.getExe pkgs.fzf} --ansi --no-sort --popup 75%
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+reload(${lib.getExe pkgs.sesh} list --hide-duplicates --icons)'
          --preview '${lib.getExe pkgs.sesh} preview {}')
        | exec ${lib.getExe pkgs.sesh} connect $in
      }
    '';
  };

  flake.wrappers.tmux = {
    pkgs,
    config,
    ...
  }: {
    imports = [lib.w.modules.default];

    package = pkgs.tmux;

    flags."-f" = config.constructFiles.config.path;

    constructFiles.config.relPath = "${config.binName}-config.conf";
    constructFiles.config.content = ''
      # General
      set -g aggressive-resize on
      set -g allow-passthrough on
      set -g automatic-rename-format '#{pane_current_command}'
      set -g base-index 1
      set -g buffer-limit 1
      set -g copy-mode-line-numbers hybrid
      set -g copy-mode-position-format '#[align=right]#{?search_timed_out,(timed out) ,#{n:search_count},(#{search_count}#{?search_count_partial,+} result#{?#{e/!=:#{search_count},1},s}) }#{e/+:#{copy_cursor_y},#{?#{==:#{pane_mode},view-mode},#{e/+:1,#{e/-:#{copy_position_limit},#{copy_position}}},#{copy_position}}}:#{e/+:1,#{copy_cursor_x}} #{e|/:#{e/*:100,#{e/+:#{copy_cursor_y},#{?#{==:#{pane_mode},view-mode},#{e/+:1,#{e/-:#{copy_position_limit},#{copy_position}}},#{copy_position}}}},#{e/+:#{copy_position_limit},#{?#{==:#{pane_mode},view-mode},#{pane_height},0}}}%' # Works in copy and view mode
      set -gF default-command 'exec #{default-shell}'
      set -g default-terminal tmux-256color
      set -g display-time 4000
      set -g escape-time 10
      set -g focus-events on
      set -g history-limit 50000
      set -g main-pane-height 50%
      set -g main-pane-width 50%
      set -g menu-border-lines rounded
      set -g mode-keys vi
      set -g mouse on
      set -g pane-base-index 1
      set -g popup-border-lines rounded
      set -g renumber-windows on
      set -g status-interval 0
      set -g status-keys emacs
      set -g tree-mode-preview-format ""
      set -ga word-separators _

      # Status
      set -g status-position top
      set -g status-left-length 0
      set -g prompt-cursor-style bar
      set -g status-justify absolute-centre
      set -g window-status-format ' #{window_index}: #{window_name} #{?#{m/r:(buffer|client|customize|tree)-mode,#{pane_mode}},󰙅 ,#{==:#{pane_mode},copy-mode}, ,#{==:#{pane_mode},clock-mode}, ,#{==:#{pane_mode},view-mode}, }#{?window_zoomed_flag,󰊓 }#{?window_bell_flag, }'
      set -gF window-status-current-format '#{window-status-format}'
      set -g window-status-separator ""
      set -g status-right ""

      # Plugins
      set -g @floax-bind '-n C-M-o'
      set-hook -ga client-attached { if -F '#{==:#{session_name},scratch}' { set -u message-style; set -F message-style '#{message-style},width=100%' } }

      bind -n C-M-z { run ${lib.getExe self.packages.${pkgs.stdenv.system}.sesh-fzf} }

      # Theme
      ${(getDefaultTheme pkgs)."tmux.conf"}
      source-file -q ~/.theme-config/tmux.conf

      # General keybindings
      bind -n C-M-c { new-window }
      bind -n C-M-p { previous-window }
      bind -n C-M-n { next-window }
      bind -n C-M-h { select-pane -L }
      bind -n C-M-j { select-pane -D }
      bind -n C-M-k { select-pane -U }
      bind -n C-M-l { select-pane -R }
      bind -n C-M-x { kill-pane }

      # Copy mode keybindings
      set-hook -ga after-copy-mode { send -X begin-selection; set -p @select 0 }

      bind -T copy-mode-vi v {
        if -F '#{@select}' {
          set -p @select 0
        } {
          set -p @select 1
          if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        }
      }
      bind -T copy-mode-vi Escape { set -p @select 0 }
      bind -T copy-mode-vi ';' { send -X clear-selection; send -X begin-selection }
      bind -T copy-mode-vi 'M-;' { send -X other-end }

      bind -T copy-mode-vi h { send -X cursor-left; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi j { send -X cursor-down; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi k { send -X cursor-up; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi l { send -X cursor-right; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi H {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X cursor-left
      }
      bind -T copy-mode-vi J {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X cursor-down
      }
      bind -T copy-mode-vi K {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X cursor-up
      }
      bind -T copy-mode-vi L {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X cursor-right
      }
      bind -T copy-mode-vi M-h { send -X back-to-indentation; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi M-l { send -X end-of-line; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi M-H {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X back-to-indentation
      }
      bind -T copy-mode-vi M-L {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X end-of-line
      }

      %hidden VARS="w=#{q:word-separators}$' \t'; s=#{q:word-separators}; l=#{q:copy_cursor_line}; x=#{copy_cursor_x};"
      bind -T copy-mode-vi w {
        if '#{E:VARS} [[ $x -eq ''${#l}-1 || ''${l:$x:2} != @(+([^"$w"])|+(["$s"])|?[_[:blank:]]) ]]' { send -X cursor-right }
        if -F '#{n:copy_cursor_line}' {} { send -X next-space; send -X start-of-line }
        if -F '#{@select}' {} { send -X begin-selection }
        if '#{E:VARS} [[ ''${l:$x} = @(*([^"$w"])|+(["$s"])) ]]' {
          send -X end-of-line
        } {
          send -X next-word
          if '#{E:VARS} [[ ''${l:$x} = _*(["$s"]) ]]' {
            send -X end-of-line
          } {
            if '#{E:VARS} [[ ''${l:$x:1} = _ ]]' { send -X next-word }
            send -X cursor-left
          }
        }
      }
      bind -T copy-mode-vi b {
        if '#{E:VARS} [[ $x -eq 0 || ''${l:$x-1:2} != @(+([^"$w"])|+(["$s"])|?[_[:blank:]]) ]]' { send -X cursor-left }
        if -F '#{n:copy_cursor_line}' {} { send -X previous-space; send -X end-of-line }
        if -F '#{@select}' {} { send -X begin-selection }
        if '#{E:VARS} [[ $x -eq 0 || ''${l:0:$x+1} = +([[:blank:]]) ]]' {
          send -X start-of-line
        } {
          if '#{E:VARS} [[ ''${l:$x-1:2} = @(+([^"$w"])|+(["$s"])|?[[:blank:]]) ]]' { send -X previous-word }
          if '#{E:VARS} [[ ''${l:$x:1} = _ ]]' { if '#{E:VARS} [[ ''${l:0:$x} = *([[:blank:]]) ]]' { send -X start-of-line } { send -X previous-word } }
        }
      }
      bind -T copy-mode-vi e {
        if '#{E:VARS} [[ $x -eq ''${#l}-1 || ''${l:$x:2} != @(+([^"$w"])|+(["$s"])|[_[:blank:]]?) ]]' { send -X cursor-right }
        if -F '#{n:copy_cursor_line}' {} { send -X next-space; send -X start-of-line }
        if -F '#{@select}' {} { send -X begin-selection }
        if '#{E:VARS} [[ ''${l:$x:2} = @(+([^"$w"])|+(["$s"])|[[:blank:]]?) ]]' { send -X next-word-end }
        if '#{E:VARS} [[ ''${l:$x:1} = _ ]]' { send -X next-word-end }
      }
      bind -T copy-mode-vi W {
        if -F '#{@select}' {
          send w
        } {
          set -p @select 1
          if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
          send w
          set -p @select 0
        }
      }
      bind -T copy-mode-vi B {
        if -F '#{@select}' {
          send b
        } {
          set -p @select 1
          if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
          send b
          set -p @select 0
        }
      }
      bind -T copy-mode-vi E {
        if -F '#{@select}' {
          send e
        } {
          set -p @select 1
          if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
          send e
          set -p @select 0
        }
      }
      bind -T copy-mode-vi M-w {
        if '#{E:VARS} [[ $x -eq ''${#l}-1 || ''${l:$x:2} = [[:blank:]][^[:blank:]] ]]' { send -X cursor-right }
        if -F '#{n:copy_cursor_line}' {} { send -X next-space; send -X start-of-line }
        if -F '#{@select}' {} { send -X begin-selection }
        if '#{E:VARS} [[ ''${l:$x} = *([^[:blank:]]) ]]' { send -X end-of-line } { send -X next-space; send -X cursor-left }
      }
      bind -T copy-mode-vi M-b {
        if '#{E:VARS} [[ $x -eq 0 || ''${l:$x-1:2} = [[:blank:]][^[:blank:]] ]]' { send -X cursor-left }
        if -F '#{n:copy_cursor_line}' {} { send -X previous-space; send -X end-of-line }
        if -F '#{@select}' {} { send -X begin-selection }
        if '#{E:VARS} [[ $x -eq 0 || ''${l:0:$x+1} = +([[:blank:]]) ]]' {
          send -X start-of-line
        } { if '#{E:VARS} [[ ''${l:$x-1:2} != [[:blank:]][^[:blank:]] ]]' {
          send -X previous-space
        } }
      }
      bind -T copy-mode-vi M-e {
        if '#{E:VARS} [[ $x -eq ''${#l}-1 || ''${l:$x:2} = [^[:blank:]][[:blank:]] ]]' { send -X cursor-right }
        if -F '#{n:copy_cursor_line}' {} { send -X next-space; send -X start-of-line }
        if -F '#{@select}' {} { send -X begin-selection }
        if '#{E:VARS} [[ ''${l:$x:2} != [^[:blank:]][[:blank:]] ]]' { send -X next-space-end }
      }
      bind -T copy-mode-vi M-W {
        if -F '#{@select}' {
          send M-w
        } {
          set -p @select 1
          if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
          send M-w
          set -p @select 0
        }
      }
      bind -T copy-mode-vi M-B {
        if -F '#{@select}' {
          send M-b
        } {
          set -p @select 1
          if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
          send M-b
          set -p @select 0
        }
      }
      bind -T copy-mode-vi M-E {
        if -F '#{@select}' {
          send M-e
        } {
          set -p @select 1
          if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
          send M-e
          set -p @select 0
        }
      }

      bind -T copy-mode-vi t { if -F '#{@select}' {} { send -X begin-selection }; command-prompt -1 -p '(jump to forward)' { send -X jump-to-forward '%%' } }
      bind -T copy-mode-vi f { if -F '#{@select}' {} { send -X begin-selection }; command-prompt -1 -p '(jump forward)' { send -X jump-forward '%%' } }
      bind -T copy-mode-vi T {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        command-prompt -1 -p '(extend to forward)' { send -X jump-to-forward '%%' }
      }
      bind -T copy-mode-vi F {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        command-prompt -1 -p '(extend forward)' { send -X jump-forward '%%' }
      }
      bind -T copy-mode-vi M-t { if -F '#{@select}' {} { send -X begin-selection }; command-prompt -1 -p '(jump to backward)' { send -X jump-to-backward '%%' } }
      bind -T copy-mode-vi M-f { if -F '#{@select}' {} { send -X begin-selection }; command-prompt -1 -p '(jump backward)' { send -X jump-backward '%%' } }
      bind -T copy-mode-vi M-T {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        command-prompt -1 -p '(extend to backward)' { send -X jump-to-backward '%%' }
      }
      bind -T copy-mode-vi M-F {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        command-prompt -1 -p '(extend backward)' { send -X jump-backward '%%' }
      }

      bind -T copy-mode-vi x {
        if -F '#{selection_active}' {} { send -X begin-selection }
        set -pF @left '#{||:#{e/<:#{copy_cursor_y},#{selection_start_y}},#{e/<:#{copy_cursor_y},#{selection_end_y}},#{&&:#{e/==:#{selection_start_y},#{selection_end_y}},#{||:#{e/<:#{copy_cursor_x},#{selection_start_x}},#{e/<:#{copy_cursor_x},#{selection_end_x}}}}}'
        if -F '#{@left}' { send -X other-end }
        if -F '#{?#{||:#{e/<:#{selection_start_y},#{selection_end_y}},#{&&:#{e/==:#{selection_start_y},#{selection_end_y}},#{e/<:#{selection_start_x},#{selection_end_x}}}},#{&&:#{e/==:#{selection_start_x},0},#{e/>=:#{selection_end_x},#{e/-:#{w:copy_cursor_line},1}}},#{&&:#{e/==:#{selection_end_x},0},#{e/>=:#{selection_start_x},#{e/-:#{w:copy_cursor_line},1}}}}' {
          if -F '#{&&:#{@left},#{e/!=:#{selection_start_y},#{selection_end_y}}}' {
            send -X other-end
            send -X cursor-down
            if -F '#{e/==:#{selection_start_y},#{selection_end_y}}' { send -X other-end }
          } {
            send -X cursor-down
            send -X end-of-line
          }
        } {
          send -X end-of-line
          send -X other-end
          send -X start-of-line
          if -F '#{||:#{!:#{@left}},#{e/==:#{selection_start_y},#{selection_end_y}}}' { send -X other-end }
        }
      }
      bind -T copy-mode-vi X {
        if -F '#{selection_active}' {} { send -X begin-selection }
        set -pF @left '#{||:#{e/<:#{copy_cursor_y},#{selection_start_y}},#{e/<:#{copy_cursor_y},#{selection_end_y}},#{&&:#{e/==:#{selection_start_y},#{selection_end_y}},#{||:#{e/<:#{copy_cursor_x},#{selection_start_x}},#{e/<:#{copy_cursor_x},#{selection_end_x}}}}}'
        if -F '#{@left}' { send -X other-end }
        if -F '#{?#{||:#{e/<:#{selection_start_y},#{selection_end_y}},#{&&:#{e/==:#{selection_start_y},#{selection_end_y}},#{e/<:#{selection_start_x},#{selection_end_x}}}},#{&&:#{e/==:#{selection_start_x},0},#{e/>=:#{selection_end_x},#{e/-:#{w:copy_cursor_line},1}}},#{&&:#{e/==:#{selection_end_x},0},#{e/>=:#{selection_start_x},#{e/-:#{w:copy_cursor_line},1}}}}' {
          if -F '#{||:#{@left},#{e/==:#{selection_start_y},#{selection_end_y}}}' {
            send -X other-end
            send -X cursor-up
          } {
            send -X cursor-up
            send -X end-of-line
            if -F '#{e/==:#{selection_start_y},#{selection_end_y}}' { send -X other-end }
          }
        } {
          send -X end-of-line
          send -X other-end
          send -X start-of-line
          if -F '#{&&:#{!:#{@left}},#{e/!=:#{selection_start_y},#{selection_end_y}}}' { send -X other-end }
        }
      }

      bind -T copy-mode-vi m { send -X next-matching-bracket; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi M {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X next-matching-bracket
      }

      bind -T copy-mode-vi C-u { send -X halfpage-up; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi C-d { send -X halfpage-down; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi C-U {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X halfpage-up
      }
      bind -T copy-mode-vi C-D {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X halfpage-down
      }

      bind -T copy-mode-vi / { if -F '#{@select}' {} { send -X clear-selection }; command-prompt -T search -p '(search down)' -i { send -X search-forward-incremental '%%' } }
      bind -T copy-mode-vi ? { if -F '#{@select}' {} { send -X clear-selection }; command-prompt -T search -p '(search up)' -i { send -X search-backward-incremental '%%' } }
      bind -T copy-mode-vi n { if -F '#{@select}' {} { send -X clear-selection }; send -X search-again }
      bind -T copy-mode-vi N { if -F '#{@select}' {} { send -X clear-selection }; send -X search-reverse }
      bind -T copy-mode-vi M-n {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X search-again
      }
      bind -T copy-mode-vi M-N {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X search-reverse
      }

      bind -T copy-mode-vi p { send -X next-prompt; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi P {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X next-prompt
      }
      bind -T copy-mode-vi M-p { send -X previous-prompt -o; if -F '#{@select}' {} { send -X begin-selection } }
      bind -T copy-mode-vi M-P {
        if -F '#{selection_active}' {} { set -pF @offset '#{e/-:#{w:search_match},1}'; send -X -FN '#{@offset}' cursor-right; send -X begin-selection; send -X -FN '#{@offset}' cursor-left }
        send -X previous-prompt -o
      }

      bind -T copy-mode-vi y { send -X copy-selection-no-clear -P }
      bind -T copy-mode-vi Enter { send -X copy-selection-and-cancel -P }
    '';
  };
}
