{
  lib,
  config,
  ...
}: {
  options.cli.nvf.mini-indentscope.enable = lib.mkEnableOption "mini.indentscope";

  config.cli.nvf.settings.mini.indentscope = lib.mkIf config.cli.nvf.mini-indentscope.enable {
    enable = true;
    setupOpts = {
      draw.delay = 0;
      draw.animation = lib.mkLuaInline "require('mini.indentscope').gen_animation.none()";
      options.try_as_border = true;
      symbol = "│";
    };
  };
}
