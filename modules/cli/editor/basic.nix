{
  lib,
  config,
  ...
}: {
  options.cli.editor.basic.enable = lib.mkEnableOption "basic options and keymaps";

  config.cli.editor.settings = lib.mkIf config.cli.editor.basic.enable {
    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true; # TODO

    globals.mapleader = " ";
    globals.maplocalleader = " ";
    opts = {
      breakindent = true;
      confirm = true;
      ignorecase = true;
      inccommand = "split";
      list = true;
      listchars = "tab:» ,multispace:·,lead: ,trail:·,nbsp:␣"; # TODO extends, precedes
      number = true;
      relativenumber = true;
      scrolloff = 9;
      shiftwidth = 2;
      sidescroll = 0;
      signcolumn = "yes";
      smartcase = true;
      smartindent = true;
      splitbelow = true;
      splitright = true;
      wrap = false;
    };

    autoCmd = lib.singleton {
      event = "TextYankPost";
      callback = config.hm.lib.nixvim.utils.mkRaw ''function() vim.hl.on_yank() end'';
    };

    keymaps = [
      {
        key = "<Esc>";
        mode = "n";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlights";
      }
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
