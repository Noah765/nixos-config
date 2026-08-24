{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.devenv.enable = lib.mkEnableOption "devenv";

    config = lib.mkIf config.cli.devenv.enable {
      wrappers.devenv.enable = true;
      core.impermanence.hm.directories = [".local/share/devenv" ".local/share/secretspec/cache"];
      core.cleanup.script = ''
        cd /home/noah
        ${lib.getExe pkgs.devenv} gc
      '';
    };
  };

  flake.wrappers.devenv = {
    pkgs,
    config,
    ...
  }: {
    imports = [lib.w.modules.default];

    package = pkgs.devenv;
    binName = "secretspec";
    exePath = "bin/secretspec";

    env.XDG_CONFIG_HOME = "${placeholder config.outputName}/${config.binName}-config";

    constructFiles.config = {
      relPath = "${config.binName}-config/secretspec/config.toml";
      builder = ''${lib.getExe' pkgs.remarshal "json2toml"} "$1" "$2"'';
      content = lib.toJSON {
        defaults = {
          provider = "cached-pass";
          profile = "development";
          providers.cached-pass.uri = "pass";
          providers.cached-pass.cache = {
            provider = "file:~/.local/state/secretspec/cache";
            max_age = "1w";
          };
        };
        audit.enable = false;
      };
    };
  };
}
