{
  lib,
  config,
  ...
}: {
  options.cli.editor.navbuddy.enable = lib.mkEnableOption "nvim-navbuddy";

  config.cli.editor.settings = lib.mkIf config.cli.editor.navbuddy.enable {
    plugins.navbuddy.enable = true;
    plugins.navbuddy.settings = {
      mappings = {
        "<BS>" = "root";
        "<C-s>" = "vsplit";
        "<C-h>" = "hsplit";
      };
      use_default_mapping = false;
      window.scrolloff = 3;
    };
    keymaps = lib.singleton {
      key = "<leader>b";
      mode = "n";
      action = config.hm.lib.nixvim.utils.mkRaw "require('nvim-navbuddy').open";
      options.desc = "Breadcrumbs navigation";
    };
    lsp.onAttach = "require('nvim-navbuddy').attach(client, bufnr)";
  };
}
