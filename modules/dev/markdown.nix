{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.dev.markdown.enable = lib.mkEnableOption "Markdown";

    config.cli.editor = lib.mkIf config.dev.markdown.enable {
      packages = [pkgs.marksman];
      languages.markdown.language-servers = ["marksman" "harper-ls" "codebook"];
    };
  };
}
