{lib, ...}: {
  nixos = {config, ...}: {
    options.cli.numbat.enable = lib.mkEnableOption "Numbat";

    config.hm.programs.numbat = lib.mkIf config.cli.numbat.enable {
      enable = true;
      settings = {
        prompt = "❯ ";
        edit-mode = "vi";
        exchange-rates.fetching-policy = "on-first-use";
      };
    };
  };
}
