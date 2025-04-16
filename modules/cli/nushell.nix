{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cli.nushell;
in {
  options.cli.nushell.enable = mkEnableOption "nushell";

  config = mkIf cfg.enable {
    os.users.defaultUserShell = pkgs.nushell;

    hm.programs.nushell = {
      enable = true;
      settings = {
        history.file_format = "sqlite";
        # TODO history.isolation
        show_banner = false;
        edit_mode = "vi";
        # TODO cursor_shape
        completions.algorithm = "fuzzy";
        # TODO completions.case_sensitive, completions.partial, completions.external.{max_results, completer}
        # TODO use_kitty_protocol, shell_integration.osc9_9
        # TODO display_errors.exit_code
        # TODO footer_mode, table.trim

        # TODO table.abbreviated_row_count = 15;
        # TODO explore, history.file_format
        filesize.metric = true;
        # color_config, footer_mode
        # TODO env.editor is wrong
        # TODO render_right_prompt_on_last_line
      };
    };

    hm.programs.nixvim.plugins.lsp.servers.nushell.enable = true;
  };
}
