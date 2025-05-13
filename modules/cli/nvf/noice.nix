{
  lib,
  config,
  ...
}: {
  options.cli.nvf.noice.enable = lib.mkEnableOption "Noice";

  config.cli.nvf.settings.ui.noice = lib.mkIf config.cli.nvf.noice.enable {
    enable = true;
    # TODO config
  };
}
