{
  lib,
  config,
  ...
}: let
  inherit (lib) concatMap flip hasPrefix mapAttrsToList mkEnableOption mkIf mkLuaInline optionalString optionalAttrs;
in {
  options.cli.nvf.mini-ai.enable = mkEnableOption "mini.ai";

  config.cli.nvf.settings = mkIf config.cli.nvf.mini-ai.enable {
    mini = {
      ai.enable = true; # TODO config, treesitter textobjects
      ai.setupOpts = {
        n_lines = 500;
        # TODO https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua#L37-L54
        custom_textobjects = {
          # TODO redefine builtin textobjects to make them work with g]
          # TODO which of these are actually useful? rename
          B = mkLuaInline "require('mini.extra').gen_ai_spec.buffer()";
          D = mkLuaInline "require('mini.extra').gen_ai_spec.diagnostic()"; # TODO remove or add which-key description
          L = mkLuaInline "require('mini.extra').gen_ai_spec.line()";
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
      };
      extra.enable = true; # TODO use inside mini.hipatterns config? remove when barely used, maybe inline ai objects
      indentscope.setupOpts.mappings.goto_top = "g[i";
      indentscope.setupOpts.mappings.goto_bottom = "g]i";
    };
    binds.whichKey.setupOpts.plugins.presets.text_objects = false;
    binds.whichKey.setupOpts.spec = let
      # TODO MatchitVisualTextObject
      # TODO registers
      textobjects = isAround:
        {
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
          "D" = "Diagnostic";
          "L" = "Line";
          "d" = "Digits";
          "N" = "Number";
        }
        // optionalAttrs config.cli.nvf.mini-indentscope.enable {"i" = "Indent scope";};
    in [
      {
        mode = ["x" "o"];
        "@1" = flip concatMap ["a" "an" "al" "i" "in" "il"] (type:
          flip mapAttrsToList (textobjects (hasPrefix "a" type)) (name: desc: {
            inherit desc;
            "@1" = type + name;
          }));
      }
      {
        mode = ["n" "x" "o"];
        "@1" = flip concatMap ["g[" "g]"] (mapping:
          flip mapAttrsToList (textobjects true) (name: desc: {
            inherit desc;
            "@1" = mapping + name;
          }));
      }
    ];
  };
}
