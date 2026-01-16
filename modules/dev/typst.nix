{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.typst.enable = lib.mkEnableOption "Typst";

  config = lib.mkIf config.dev.typst.enable {
    dependencies = ["apps.browser"];

    core.impermanence.hm.directories = [".cache/typst"];

    cli.editor = {
      packages = [pkgs.tinymist];
      settings.keys.normal."C-p" = '':lsp-workspace-command tinymist.pinMain "%sh{'%{buffer_name}' | path expand}"'';
      settings.keys.normal.space.o = ['':lsp-workspace-command tinymist.doStartBrowsingPreview ["--invert-colors=auto"]'' ":! qutebrowser --target window --loglevel warning http://127.0.0.1:23625"];
      languages.typst.language-servers = ["tinymist" "harper-ls" "codebook"];
      languageServers.tinymist.config.tinymist.completion.symbol = "stepless";
      languageServers.tinymist.config.tinymist.lint.enabled = true;
    };
  };
}
