{lib, ...}: {
  keymaps = [
    {
      key = "<leader>f";
      mode = "n";
      action = lib.nixvim.utils.mkRaw "require('conform').format";
      options.desc = "Format";
    }
    {
      key = "<leader>tf";
      mode = "n";
      action = lib.nixvim.utils.mkRaw "function() vim.g.disable_format_on_save = not vim.g.disable_format_on_save end";
      options.desc = "Toggle format on save";
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
    formatters.nix_fmt.args = ["fmt"];
    formatters.nix_fmt.command = "nix";
    formatters_by_ft.nix = ["nix_fmt"];
  };
}
