{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    (lib.mkAliasOptionModule ["cli" "editor" "packages"] ["hm" "programs" "helix" "extraPackages"])
    (lib.mkAliasOptionModule ["cli" "editor" "settings"] ["hm" "programs" "helix" "settings"])
    (lib.mkAliasOptionModule ["cli" "editor" "languageServers"] ["hm" "programs" "helix" "languages" "language-server"])
  ];

  options.cli.editor.enable = lib.mkEnableOption "Helix";
  options.cli.editor.languages = lib.mkOption {
    type = lib.types.attrsOf (lib.types.addCheck (pkgs.formats.toml {}).type lib.isAttrs);
    default = {};
    description = "Language specific configuration.";
  };

  config = lib.mkIf config.cli.editor.enable {
    theme.stylix.hmTargets.helix.enable = false;

    hm.programs.helix = {
      enable = true;
      defaultEditor = true;

      extraPackages = [pkgs.harper];

      settings.editor = {
        scrolloff = 9;
        shell = lib.mkIf config.cli.nushell.enable [(lib.getExe pkgs.nushell) "-c"];
        line-number = "relative";
        completion-timeout = 5;
        completion-trigger-len = 1;
        completion-replace = true;
        color-modes = true;
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        end-of-line-diagnostics = "hint";
        statusline.left = ["mode" "file-name" "read-only-indicator" "file-modification-indicator" "spacer" "spinner"];
        statusline.mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
        lsp.display-inlay-hints = true;
        cursor-shape.insert = "bar";
        auto-save.focus-lost = true;
        soft-wrap.enable = true;
        inline-diagnostics.cursor-line = "warning";
      };

      languages.language = lib.mapAttrsToList (name: value: {inherit name;} // value) config.cli.editor.languages;

      languages.language-server = {
        harper-ls.config.harper-ls.linters.SpellCheck = false;
        harper-ls.config.harper-ls.isolateEnglish = true;

        codebook.command = lib.getExe pkgs.codebook;
        codebook.args = ["serve"];
      };
    };

    hm.xdg.configFile."codebook/codebook.toml".source = (pkgs.formats.toml {}).generate "codebook.toml" {dictionaries = ["en_us" "en_gb" "de"];};
  };
}
