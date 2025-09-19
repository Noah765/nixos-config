{
  lib,
  config,
  ...
}: {
  options.cli.editor.mini-jump2d.enable = lib.mkEnableOption "mini-jump2d";

  config.cli.editor.settings = lib.mkIf config.cli.editor.mini-jump2d.enable {
    plugins.mini.modules.jump2d = {
      labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      view.n_steps_ahead = 10;
    };
    keymaps = lib.singleton {
      key = "<CR>";
      mode = ["n" "x" "o"];
      action = config.hm.lib.nixvim.utils.mkRaw "function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end";
      options.desc = "2d jump";
    };
  };
}
