{
  self,
  lib,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.man.enable = lib.mkEnableOption "batman";

    config = lib.mkIf config.cli.man.enable {
      environment.systemPackages = [self.packages.${pkgs.stdenv.system}.batman];
      documentation.man.cache.enable = true;
    };
  };

  perSystem = {pkgs, ...}: {
    packages.batman = pkgs.bat-extras.batman.override (previous: {
      buildBatExtrasPkg = previous.buildBatExtrasPkg.override {
        bat = self.wrappers.bat.wrap {inherit pkgs;};
      };
    });
  };
}
