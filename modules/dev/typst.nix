{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.typst.enable = lib.mkEnableOption "Typst";

  config = lib.mkIf config.dev.typst.enable {
    core.impermanence.hm.directories = [".cache/typst"];

    dev.formatters.typst.fileExtension = "typ";
    dev.formatters.typst.command = "typst-fmt";

    cli.editor = {
      packages = [pkgs.tinymist];
      settings.keys.normal."C-p" = '':lsp-workspace-command tinymist.pinMain "%sh{'%{buffer_name}' | path expand}"'';
      languages.typst.auto-format = true;
      languageServers.tinymist.config.tinymist = {
        completion.symbol = "stepless";
        lint.enabled = true;
        preview.background.enabled = true;
        preview.background.args = ["--invert-colors=auto" "--open"];
      };
    };
  };
}
