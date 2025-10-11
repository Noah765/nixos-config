{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.nix.enable = lib.mkEnableOption "Nix development tools";

  config = lib.mkIf config.dev.nix.enable {
    dev.formatters.nix = ["nix" "fmt"];

    cli.editor = {
      lsp.servers.nixd.enable = true;
      lsp.servers.nixd.config.settings.nixd.options.modulix.expr = "(builtins.getFlake \"/etc/nixos\").modulixConfigurations.primary.options";

      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix];

      linting.lintersByFt.nix = ["statix" "deadnix"];
    };
  };
}
