{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.rust.enable = lib.mkEnableOption "Rust";

  config = lib.mkIf config.dev.rust.enable {
    core.impermanence.hm.directories = [".cargo"];

    cli.editor = {
      packages = [pkgs.rust-analyzer pkgs.rustc];
      languages.rust.language-servers = ["rust-analyzer" "codebook"];
    };
  };
}
