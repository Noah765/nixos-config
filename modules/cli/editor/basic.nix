{
  lib,
  config,
  ...
}: {
  options.cli.editor.basic.enable = lib.mkEnableOption "basic options and keymaps";

  config.cli.editor.settings = lib.mkIf config.cli.editor.basic.enable {
    keymaps = [
      {
        key = "<leader>q";
        mode = "n";
        action = config.hm.lib.nixvim.utils.mkRaw "function() vim.cmd(vim.fn.getqflist({ winid = 0 }).winid == 0 and 'copen' or 'cclose') end";
        options.desc = "Toggle quickfix list";
      }
      {
        key = "<leader>d";
        mode = "n";
        action = "<cmd>cnext<CR>";
        options.desc = "Next quickfix item";
      }
      {
        key = "<leader>u";
        mode = "n";
        action = "<cmd>cprevious<CR>";
        options.desc = "Previous quickfix item";
      }
    ];
  };
}
