{
  lib,
  config,
  ...
}: {
  options.dev.qml.enable = lib.mkEnableOption "QML";

  config = lib.mkIf config.dev.qml.enable {
    cli.vcs.jj.fix.qml = {
      command = "qmlformat $path";
      patterns = ["glob:**/*.qml"];
    };

    cli.editor.languages.qml = {
      language-servers = ["qmlls" "codebook"];
      auto-format = true;
    };
  };
}
