{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.man.enable = lib.mkEnableOption "batman";

    config = lib.mkIf config.cli.man.enable {
      environment.systemPackages = [pkgs.bat-extras.batman];
      documentation.man.cache.enable = true;
    };
  };
}
