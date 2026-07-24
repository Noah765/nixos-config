{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.direnv.enable = lib.mkEnableOption "direnv";

    config = lib.mkIf config.cli.direnv.enable {
      wrappers.direnv.enable = true;
      core.impermanence.hm.directories = [".local/share/direnv/allow"];
      core.cleanup.script = "HOME=/home/noah ${lib.getExe pkgs.direnv} prune";
    };
  };

  flake.wrappers.direnv = {
    pkgs,
    config,
    ...
  }: {
    imports = [lib.w.modules.default];

    package = pkgs.direnv;

    env.DIRENV_CONFIG = "${placeholder config.outputName}/${config.binName}-config";

    constructFiles.config = {
      relPath = "${config.binName}-config/direnv.toml";
      builder = ''${lib.getExe' pkgs.remarshal "json2toml"} "$1" "$2"'';
      content = lib.toJSON {
        global = {
          strict_env = true;
          warn_timeout = 0;
          log_format = "-";
        };
      };
    };

    constructFiles.nix-direnv = {
      relPath = "${config.binName}-config/lib/nix-direnv.sh";
      content = lib.readFile "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };
  };
}
