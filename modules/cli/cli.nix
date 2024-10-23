{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; let
  cfg = config.cli.cli;
in {
  options.cli.cli.enable = mkEnableOption "the default CLI configuration";

  # TODO Use the ble.sh hm module once it gets merged https://github.com/nix-community/home-manager/pull/3238
  config = mkIf cfg.enable {
    hm.programs.bash = {
      enable = true;
      enableCompletion = false;
      # TODO Maybe add environment.pathsToLink = [ "/share/bash-completion" ]; for completion on system packages like systemd
      #bashrcExtra = let
      #  stringifyAttrs = cmd: options:
      #    concatStringsSep "\n"
      #    (mapAttrsToList (k: v: "${cmd} ${k}=${escapeShellArg v}") options);
      #  stringifyLists = cmd: options:
      #    concatStringsSep "\n" (map (v: "${cmd} ${escapeShellArg v}") options);

      #  optionsStr = stringifyAttrs "bleopt" {default_keymap = "vi";};
      #  facesStr = stringifyAttrs "ble-face" (with (mapAttrs (_: x: "fg=${x}") osConfig.lib.stylix.colors.withHashtag); {
      #    # Editing
      #    region = "";
      #    region_target = "";
      #    region_match = "";
      #    region_insert = "";
      #    disabled = "";
      #    overwrite_mode = "";
      #    vbell = "";
      #    vbell_flash = "";
      #    vbell_erase = "";
      #    prompt_status_line = "";

      #    # Auto completion
      #    auto_complete = "";
      #    #menu_filter_fixed = "";
      #    #menu_filter_input = "";

      #    # TODO What is this?
      #    cmdinfo_cd_cdpath = "";

      #    # Syntax highlighting
      #    syntax_default = "";
      #    # TODO Choose to base this of nvim or on base64, maybe change everforest nvim theme into base16?
      #    syntax_command = base0A; # TODO What is this?
      #    syntax_quoted = base0C;
      #    syntax_quotation = base0C;
      #    syntax_escape = base0B;
      #    syntax_expr = base09;
      #    syntax_error = "";
      #    syntax_varname = "";
      #    syntax_param_expansion = base0D;
      #    syntax_history_expansion = base0E;
      #    syntax_function_name = "";
      #    syntax_comment = base03;
      #    syntax_glob = "";
      #    syntax_brace = "";
      #    syntax_tilde = "";
      #    syntax_document = "";
      #    syntax_document_begin = "";
      #    command_builtin_dot = "";
      #    command_builtin = "";
      #    command_alias = "";
      #    command_function = "";
      #    command_file = "";
      #    command_keyword = "";
      #    command_jobs = "";
      #    command_directory = "";
      #    argument_option = "";
      #    argument_error = "";
      #    filename_directory = "";
      #    filename_directory_sticky = "";
      #    filename_link = "";
      #    filename_orphan = "";
      #    filename_setuid = "";
      #    filename_setgid = "";
      #    filename_executable = "";
      #    filename_other = "";
      #    filename_socket = "";
      #    filename_pipe = "";
      #    filename_character = "";
      #    filename_block = "";
      #    filename_warning = "";
      #    filename_url = "";
      #    filename_ls_colors = "";
      #    varname_unset = "";
      #    varname_export = "";
      #    varname_array = "";
      #    varname_hash = "";
      #    varname_number = "";
      #    varname_readonly = "";
      #    varname_transform = "";
      #    varname_empty = "";
      #    varname_expr = "";
      #  });
      #  importsStr = stringifyLists "ble-import" [];

      #  blerc = pkgs.writeTextFile {
      #    name = "blerc";
      #    text = concatStringsSep "\n" [
      #      optionsStr
      #      facesStr
      #      importsStr
      #    ];
      #    checkPhase = "${pkgs.stdenv.shellDryRun} \"$target\"";
      #  };
      #in
      #  mkBefore "[[ $- == *i* ]] && source '${pkgs.blesh}/share/blesh/ble.sh' --noattach --rcfile=${blerc}";
      #initExtra = mkAfter "[[ \${BLE_VERSION-} ]] && ble-attach";
    };
  };
}
