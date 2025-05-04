{
  lib,
  config,
  ...
}: {
  options.cli.nvf.navbuddy.enable = lib.mkEnableOption "Navbuddy";

  config.cli.nvf.settings = lib.mkIf config.cli.nvf.navbuddy.enable {
    ui.breadcrumbs.enable = true;
    ui.breadcrumbs.navbuddy = {
      enable = true;
      mappings = {
        root = "<BS>";
        vsplit = "<C-s>";
        hsplit = "<C-h>";
      };
      setupOpts = {
        use_default_mappings = false;
        window.scrolloff = 3;
      };
    };
    keymaps = [
      {
        key = "<leader>b";
        mode = "n";
        action = "navbuddy.open";
        lua = true;
        desc = "Breadcrumbs navigation";
      }
    ];
  };
}
