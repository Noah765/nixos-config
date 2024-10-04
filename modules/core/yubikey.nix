{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.yubikey;
in {
  options.core.yubikey.enable = mkEnableOption "using a YubiKey for login and sudo access";

  config = mkIf cfg.enable {
    os.security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };

    core.impermanence.hm.directories = [".config/Yubico"];
  };
}
