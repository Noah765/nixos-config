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
      languages.typst.auto-format = true;
      languageServers.tinymist.config.tinymist.preview.background.enabled = true;
      languageServers.tinymist.config.tinymist.preview.background.args = ["--invert-colors=auto" "--ignore-system-fonts" "--open"];
    };
  };
}
