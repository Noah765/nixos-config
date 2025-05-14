{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.cli.nushell.enable = mkEnableOption "nushell";

  config = mkIf config.cli.nushell.enable {
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
        use_kitty_protocol = config.apps.kitty.enable;
        display_errors.termination_signal = false;
        footer_mode = "auto";
        table.footer_inheritance = true;
        table.missing_value_symbol = "❌";
      };
    };
  };
}
