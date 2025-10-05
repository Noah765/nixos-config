{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.java.enable = lib.mkEnableOption "Java";

  config.cli = lib.mkIf config.dev.java.enable {
    vcs.jj.fix.java-fmt = {
      command = "java-fmt";
      patterns = ["glob:**/*.java"];
    };

    editor = {
      lsp.servers.jdtls.enable = true;

      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.java];

      formatting = {
        formatters.java-fmt.command = "java-fmt";
        formattersByFt.java = ["java-fmt"];
      };
    };
  };
}
