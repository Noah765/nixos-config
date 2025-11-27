{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.java.enable = lib.mkEnableOption "Java";

  config = lib.mkIf config.dev.java.enable {
    dev.formatters.java = "java-fmt";

    cli.editor.packages = [pkgs.jdt-language-server];
    cli.editor.languages.java.language-servers = ["jdtls" "codebook"];
  };
}
