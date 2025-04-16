{
  hm.programs.nixvim = {
    plugins.mini = {
      enable = true;
      # TODO Check out the other modules that mini offers
      modules = {
        # TODO goto_left, goto_right don't work
        ai.n_lines = 500;
        # TODO Remove if unused
        operators = {};
        pairs.mappings = let
          bracketPatternAfter = "[^%w%.%$({%[]";
          bracketPattern = "[^\\]${bracketPatternAfter}";
          angleBracketPattern = "%w${bracketPatternAfter}";
          getQuotePattern = x: "[^\\${x}%w]%W";
        in {
          "(".neigh_pattern = bracketPattern;
          "{".neigh_pattern = bracketPattern;
          "[".neigh_pattern = bracketPattern;
          "<" = {
            action = "open";
            pair = "<>";
            neigh_pattern = angleBracketPattern;
          };
          ">" = {
            action = "close";
            pair = "<>";
            neigh_pattern = angleBracketPattern;
          };
          "\"".neigh_pattern = getQuotePattern "\"";
          "'".neigh_pattern = getQuotePattern "'";
          "`".neigh_pattern = getQuotePattern "`";
        };
        statusline = {};
        surround = {};
      };
    };
    extraConfigLua = "require('mini.statusline').section_location = function() return '%2l:%-2v' end";
  };
}
