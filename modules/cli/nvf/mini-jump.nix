{
  lib,
  config,
  ...
}: {
  options.cli.nvf.mini-jump.enable = lib.mkEnableOption "mini.jump";

  config.cli.nvf.settings.mini.jump = lib.mkIf config.cli.nvf.mini-jump.enable {
    enable = true;
    setupOpts.delay.highlight = 0;
  };
}
