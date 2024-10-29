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
        pairs.mappings = {
          "(".neigh_pattern = "[^\\][^%w({%[]";
          "{".neigh_pattern = "[^\\][^%w({%[]";
          "[".neigh_pattern = "[^\\][^%w({%[]";
          "\"".neigh_pattern = "[^\\\"({%[%w]%W";
          "'".neigh_pattern = "[^\\'({%[%w]%W";
          "`".neigh_pattern = "[^\\`({%[%w]%W";
        };
        statusline = {};
        surround = {};
      };
    };
    extraConfigLua = "require('mini.statusline').section_location = function() return '%2l:%-2v' end";
  };
}
