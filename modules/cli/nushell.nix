{
  lib,
  pkgs,
  config,
  ...
}: {
  options.cli.nushell.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf config.cli.nushell.enable {
    os.users.defaultUserShell = pkgs.nushell;

    core.impermanence.hm.files = [".config/nushell/history.sqlite3"];
    hm.programs.nushell = {
      enable = true;
      environmentVariables = config.hm.home.sessionVariables; # TODO https://github.com/nix-community/home-manager/issues/4313
      # TODO keybindings, completions, menus, color scheme and prompt
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
      };
    };
  };
}
