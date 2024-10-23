{
  hm.programs.nixvim.opts = {
    number = true;
    relativenumber = true;
    showmode = false;
    clipboard = "unnamedplus"; # TODO Schedule?
    #   breakindent = true;
    #   undofile = true; # TODO Sessions
    ignorecase = true;
    smartcase = true;
    signcolumn = "yes";
    #   updatetime = 250; TODO Experiment with update times
    #   timeoutlen = 300;
    splitright = true;
    splitbelow = true;
    list = true;
    listchars = {
      tab = "» ";
      trail = "·";
      nbsp = "␣";
    };
    inccommand = "split";
    # TODO cursorline = true;
    scrolloff = 9;
    spell = true;
  };
}
