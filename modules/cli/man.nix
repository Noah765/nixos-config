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
      cli.nushell.shellAliases.man = "batman";
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
