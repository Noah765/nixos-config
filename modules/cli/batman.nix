{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.batman.enable = lib.mkEnableOption "batman";

    config = lib.mkIf config.cli.batman.enable {
      environment.systemPackages = [pkgs.bat-extras.batman];
      documentation.man.cache.enable = true;
    };
  };
}
