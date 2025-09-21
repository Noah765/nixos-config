{
  lib,
  config,
  ...
}: {
  imports = [
    (lib.mkAliasOptionModule ["cli" "editor" "formatting" "formatters"] ["cli" "editor" "settings" "plugins" "conform-nvim" "settings" "formatters"])
    (lib.mkAliasOptionModule ["cli" "editor" "formatting" "formattersByFt"] ["cli" "editor" "settings" "plugins" "conform-nvim" "settings" "formatters_by_ft"])
  ];

  options.cli.editor.formatting.enable = lib.mkEnableOption "formatting using conform-nvim";

  config.cli.editor.settings = lib.mkIf config.cli.editor.formatting.enable {
    keymaps = [
      {
        key = "<leader>f";
        mode = "n";
        action = config.hm.lib.nixvim.utils.mkRaw "require('conform').format";
        options.desc = "Format";
      }
      {
        key = "<leader>tf";
        mode = "n";
        action = config.hm.lib.nixvim.utils.mkRaw "function() vim.g.disable_format_on_save = not vim.g.disable_format_on_save end";
        options.desc = "Format on save";
      }
    ];
    plugins.conform-nvim.enable = true;
    plugins.conform-nvim.settings = {
      default_format_opts.lsp_format = "fallback";
      default_format_opts.timeout_ms = 5000;
      format_on_save = ''
        function()
          if vim.g.disable_format_on_save then return end
          return { timeout_ms = 250 }
        end
      '';
    };
  };
}
