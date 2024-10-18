{
  lib,
  pkgs,
  ...
}: {
  hm.programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";
        format_on_save.timeout_ms = 1000;
        formatters_by_ft.nix = ["alejandra"];
        formatters.alejandra.command = lib.getExe pkgs.alejandra;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>f";
        action.__raw = "function() require('conform').format { async = true } end";
        options.desc = "Format buffer";
      }
    ];
  };
}
