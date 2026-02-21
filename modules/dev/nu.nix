{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.dev.nu.enable = lib.mkEnableOption "Nu";

    config.cli.editor = lib.mkIf config.dev.nu.enable {
      packages = [pkgs.nushell];
      languages.nu.language-servers = ["nu-lsp" "codebook"];
    };
  };
}
