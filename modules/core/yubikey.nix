{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.core.yubikey;
in {
  options.core.yubikey.enable = mkEnableOption "using a YubiKey for login and sudo access";

  config.os.security.pam = mkIf cfg.enable {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    u2f.settings.authfile = pkgs.writeText "u2f-mappings" "noah:7s47t+qdwDRrR2Q2xTPY4cj4i83SVaTu6QZStuVO0bj0mW67Uj8yrW8rdRiQuhe3mF8n/tP0YERLT8fBnxdh0Q==,GtG20Gc4x16lpa7SSWFA5sIJw8A/WWWpq2FuuLAjOinuVD75X+qXaB0K8EyKTFdlqIPlROc6GHCckArbenSJWw==,es256,+presence";
  };
}
