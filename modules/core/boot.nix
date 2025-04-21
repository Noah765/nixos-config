{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.core.boot.enable = mkEnableOption "the default boot configuration";

  config.os.boot = mkIf config.core.boot.enable {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.enable = true;
  };
}
