{
  hm.programs.nixvim.autoCmd = [
    {
      event = "TextYankPost";
      desc = "Highlight when yanking text";
      callback.__raw = "function() vim.highlight.on_yank() end";
    }
  ];
}
