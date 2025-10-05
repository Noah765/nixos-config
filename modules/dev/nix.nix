{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.nix.enable = lib.mkEnableOption "Nix development tools";

  config = lib.mkIf config.dev.nix.enable {
    hm.home.packages = with pkgs; [alejandra statix deadnix];

    cli.vcs.jj.fix.nix-fmt = {
      command = ["nix" "fmt"];
      patterns = ["glob:**/*.nix"];
    };
    cli.editor = {
      lsp.servers.nixd.enable = true;
      lsp.servers.nixd.settings.settings.nixd.options.modulix.expr = "(builtins.getFlake \"/etc/nixos\").modulixConfigurations.primary.options";

      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix];

      formatting.formatters.nix-fmt = {
        command = "nix";
        args = ["fmt"];
      };
      formatting.formattersByFt.nix = ["nix-fmt"];
    };
  };
}
