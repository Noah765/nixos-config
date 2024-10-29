{
  hm.programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlights";
    }

    {
      mode = "n";
      key = "<C-S-h>";
      action = "<C-w>H";
      options.desc = "Move window left";
    }
    {
      mode = "n";
      key = "<C-S-j>";
      action = "<C-w>J";
      options.desc = "Move window down";
    }
    {
      mode = "n";
      key = "<C-S-k>";
      action = "<C-w>K";
      options.desc = "Move window up";
    }
    {
      mode = "n";
      key = "<C-S-l>";
      action = "<C-w>L";
      options.desc = "Move window right";
    }
  ];
}
