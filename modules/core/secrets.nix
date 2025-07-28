{
  lib,
  pkgs,
  config,
  ...
}: {
  options.core.secrets.enable = lib.mkEnableOption "using a YubiKey for login and sudo access and password-store to store passwords";

  config = lib.mkIf config.core.secrets.enable {
    # See https://github.com/drduh/YubiKey-Guide
    # TODO Integrate https://github.com/maximbaz/yubikey-touch-detector into my DE
    hm = {
      programs.gpg = {
        enable = true;
        mutableKeys = false;
        mutableTrust = false;
        publicKeys = [
          {
            source = ./D1EF958D2B5FED0A-2025-07-28.asc;
            trust = "ultimate";
          }
        ];
        settings = {
          armor = true;
          no-greeting = true;
          require-secmem = true;
          throw-keyids = true;
        };
      };
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 60;
        maxCacheTtl = 120;
        noAllowExternalCache = true;
        pinentry.package = pkgs.pinentry-curses;
      };

      programs.password-store.enable = true;
    };
    core.impermanence.hm.directories = [".local/share/password-store"];

    # TODO
    os.security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    os.security.pam.u2f.settings.authfile = pkgs.writeText "u2f-mappings" "noah:7s47t+qdwDRrR2Q2xTPY4cj4i83SVaTu6QZStuVO0bj0mW67Uj8yrW8rdRiQuhe3mF8n/tP0YERLT8fBnxdh0Q==,GtG20Gc4x16lpa7SSWFA5sIJw8A/WWWpq2FuuLAjOinuVD75X+qXaB0K8EyKTFdlqIPlROc6GHCckArbenSJWw==,es256,+presence";
  };
}
