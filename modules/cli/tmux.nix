{
  lib,
  getDefaultTheme,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "tmux" "enable"] ["wrappers" "tmux" "enable"])];

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
    set -g status-left '#[bold,fg=${theme.activeFg},bg=${theme.activeBg}] #{session_name} #[default,fg=${theme.inactiveFg}] #{s|#{HOME}|~:session_path}'
    set -g message-style width=30%,fill=${theme.tabLineBg},bg=${theme.tabLineBg}
    set -g window-status-style fg=${theme.inactiveFg},bg=${theme.inactiveBg}
    set -g window-status-current-style bold,fg=${theme.activeFg},bg=${theme.activeBg}
    set -g window-status-bell-style default
  '';

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
      set -g copy-mode-position-format '#[align=right]#{?search_timed_out,(timed out) ,search_present,(#{search_count}#{?search_count_partial,+} results) }#{e/+:#{copy_cursor_y},#{?#{==:#{pane_mode},view-mode},#{e/+:1,#{e/-:#{copy_position_limit},#{copy_position}}},#{copy_position}}}:#{e/+:1,#{copy_cursor_x}} #{e|/:#{e/*:100,#{e/+:#{copy_cursor_y},#{?#{==:#{pane_mode},view-mode},#{e/+:1,#{e/-:#{copy_position_limit},#{copy_position}}},#{copy_position}}}},#{e/+:#{copy_position_limit},#{?#{==:#{pane_mode},view-mode},#{pane_height},0}}}%' # Works in copy and view mode
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

      # Theme
      ${(getDefaultTheme pkgs)."tmux.conf"}
      source-file -q ~/.theme-config/tmux.conf

      # General keybindings
      bind -n C-M-c new-window
      bind -n C-M-p previous-window
      bind -n C-M-n next-window
      bind -n C-M-s split-window
      bind -n C-M-v split-window -h
      bind -n C-M-h select-pane -L
      bind -n C-M-j select-pane -D
      bind -n C-M-k select-pane -U
      bind -n C-M-l select-pane -R
      bind -n C-M-x kill-pane
  };
}
