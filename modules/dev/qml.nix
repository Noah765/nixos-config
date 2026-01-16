{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.qml.enable = lib.mkEnableOption "QML";

  config = lib.mkIf config.dev.qml.enable {
    cli.editor.packages = [pkgs.kdePackages.qtdeclarative];
    cli.editor.languages.qml.language-servers = ["qmlls" "codebook"];
  };
}
