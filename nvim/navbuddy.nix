{lib, ...}: {
  plugins.navbuddy = {
    enable = true;
    mappings = {
      "<BS>" = "root";
      "<C-s>" = "vsplit";
      "<C-h>" = "hsplit";
    };
    useDefaultMapping = false;
    window.scrolloff = 3;
  };
  keymaps = lib.singleton {
    key = "<leader>b";
    mode = "n";
    action = lib.nixvim.utils.mkRaw "require('nvim-navbuddy').open";
    options.desc = "Breadcrumbs navigation";
  };
  lsp.onAttach = "require('nvim-navbuddy').attach(client, bufnr)";
}
