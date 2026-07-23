{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.pass.enable = lib.mkEnableOption "the password manager pass";

    config = lib.mkIf config.cli.pass.enable {
      hm.programs = {
        password-store.enable = true;

        # See https://github.com/drduh/YubiKey-Guide
        gpg = {
          enable = true;
          mutableKeys = false;
          mutableTrust = false;
          publicKeys = lib.singleton {
            source = ./public-key.asc;
            trust = "ultimate";
          };
          settings = {
            no-greeting = true;
            require-secmem = true;
            throw-keyids = true;
          };
        };
      };

      hm.services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 60;
        maxCacheTtl = 60;
        noAllowExternalCache = true;
        pinentry.package = pkgs.pinentry-curses;
      };

      core.impermanence.hm.directories = [".password-store"];
    };
  };
}
