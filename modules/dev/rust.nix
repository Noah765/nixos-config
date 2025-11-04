{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.rust.enable = lib.mkEnableOption "Rust";

  config = lib.mkIf config.dev.rust.enable {
    core.impermanence.hm.directories = [".cargo"];

    cli.vcs.jj.fix.rust = {
      command = "rustfmt";
      patterns = ["glob:**/*.rs"];
    };

    cli.editor = {
      packages = with pkgs; [cargo rust-analyzer rustc];
      languages.rust.language-servers = ["rust-analyzer" "codebook"];
    };
  };
}
