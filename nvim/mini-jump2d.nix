{lib, ...}: {
  plugins.mini.modules.jump2d = {
    labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    view.n_steps_ahead = 10;
  };
  keymaps = lib.singleton {
    key = "<CR>";
    mode = ["n" "x" "o"];
    action = lib.nixvim.utils.mkRaw "function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end";
    options.desc = "2d jump";
  };
}
