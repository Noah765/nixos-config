{
  lib,
  config,
  ...
}: {
  options.cli.nvf.mini-jump2d.enable = lib.mkEnableOption "mini.jump2d";

  config.cli.nvf.settings = lib.mkIf config.cli.nvf.mini-jump2d.enable {
    mini.jump2d.enable = true;
    mini.jump2d.setupOpts = {
      labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      view.n_steps_ahead = 10;
    };
    keymaps = [
      {
        key = "<CR>";
        mode = ["n" "x" "o"];
        action = "function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end";
        lua = true;
        desc = "2d jump";
      }
    ];
  };
}
