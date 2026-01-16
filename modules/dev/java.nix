{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.java.enable = lib.mkEnableOption "Java";

  config = lib.mkIf config.dev.java.enable {
    cli.editor.packages = [pkgs.jdt-language-server];
    cli.editor.languages.java.language-servers = ["jdtls" "codebook"];
  };
}
