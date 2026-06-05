{lib, ...}: {
  nixos = {config, ...}: {
    options.cli.basic.enable = lib.mkEnableOption "basic cli programs";
    options.cli.basic.fzf.enable = lib.mkEnableOption "fzf" // {default = true;};

    config = lib.mkIf config.cli.basic.enable {
      hm.programs.fzf.enable = config.cli.basic.fzf.enable;
      hm.programs.fzf.defaultOptions = [
        "--style=full"
        "--margin=0,1"
        "--cycle"
        "--scroll-off=9"
        "--jump-labels=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "--no-scrollbar"
        "--prompt='❯ '"
        "--preview-window=66%"
        "--bind=ctrl-d:preview-half-page-down"
        "--bind=ctrl-u:preview-half-page-up"
        "--bind=ctrl-w:jump"
      ];
    };
  };
}
