{lib, ...}: let
  inherit (lib) concatMap flip hasPrefix mapAttrsToList mkLuaInline optionalString;
in {
  plugins.mini.modules = {
    # TODO config, treesitter textobjects
    ai.n_lines = 500;
    # TODO https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua#L37-L54
    ai.custom_textobjects = {
      # TODO redefine builtin textobjects to make them work with g]
      # TODO which of these are actually useful? rename
      B = mkLuaInline "require('mini.extra').gen_ai_spec.buffer()";
      d = ["%f[%d]%d+"];
      N = [
        [
          "-%d[%d_]*%.%d[%d_]*" # -1.1
          "%f[-%d_]%d[%d_]*%.%d[%d_]*" # 1.1             [^-_] -> %d
          "%f[%d_]_+()()%d[%d_]*%.%d[%d_]*()()" # _1.1   %D    -> _
          "-%d[%d_]*%f[^%d_.]" # -1                                    [%d_] -> [^.]
          "()()-%d[%d_]*()()%.%f[^%d.]" # -1.                          %.    -> %D
          "()()-%d[%d_]*()()%.%." # -1..
          "%f[-%d_]%d[%d_]*%f[^%d_.]" # 1                [^-_] -> %d   [%d_] -> [^.]
          "%f[-%d_]()()%d[%d_]*()()%.%f[^%d.]" # 1.      [^-_] -> %d   %.    -> %D
          "%f[-%d_]()()%d[%d_]*()()%.%." # 1..           [^-_] -> %d
          "%f[%d_]_+()()%d[%d_]*()()%f[^%d_.]" # _1      %D    -> _    [%d_] -> [^.]
          "%f[%d_]_+()()%d[%d_]*()()%.%f[^%d.]" # _1.    %D    -> _    %.    -> %D
          "%f[%d_]_+()()%d[%d_]*()()%.%." # _1..         %D    -> _
        ]
      ];
    };
    indentscope.mappings.goto_top = "g[i";
    indentscope.mappings.goto_bottom = "g]i";
  };
  plugins.which-key.settings = {
    plugins.presets.text_objects = false;
    spec = let
      # TODO MatchitVisualTextObject
      # TODO registers
      textobjects = isAround: {
        # Builtins
        # TODO redefine using mini.ai or remove from goto mappings
        "w" = "Word${optionalString isAround " with ws"}";
        "W" = "WORD${optionalString isAround " with ws"}";
        "s" = "Sentence${optionalString isAround " with ws"}";
        "p" = "Paragraph${optionalString isAround " with ws"}";

        # mini.ai
        "(" = "() block";
        "{" = "{} block";
        "[" = "[] block";
        "<" = "<> block";
        ")" = "() block${optionalString (!isAround) " with ws"}";
        "}" = "{} block${optionalString (!isAround) " with ws"}";
        "]" = "[] block${optionalString (!isAround) " with ws"}";
        ">" = "<> block${optionalString (!isAround) " with ws"}";
        "b" = "(){}[] block${optionalString (!isAround) " with ws"}";
        "\"" = "\" string";
        "'" = "' string";
        "`" = "` string";
        "q" = "\"'` string";
        "?" = "User prompt";
        "t" = "Tag";
        "f" = "Function call"; # TODO replace with treesitter
        "a" = "Argument"; # TODO replace with treesitter
        "*" = "Non latin separator";

        # Custom
        "B" = "Buffer${optionalString isAround " with ws"}";
        "d" = "Digits";
        "N" = "Number";
        "i" = "Indent scope";
      };
    in [
      {
        mode = ["x" "o"];
        __unkeyed = flip concatMap ["a" "an" "al" "i" "in" "il"] (type:
          flip mapAttrsToList (textobjects (hasPrefix "a" type)) (name: desc: {
            inherit desc;
            __unkeyed = type + name;
          }));
      }
      {
        mode = ["n" "x" "o"];
        __unkeyed = flip concatMap ["g[" "g]"] (mapping:
          flip mapAttrsToList (textobjects true) (name: desc: {
            inherit desc;
            __unkeyed = mapping + name;
          }));
      }
    ];
  };
}
