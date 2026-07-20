{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.dev.basic.enable = lib.mkEnableOption "basic development tools";

    config = lib.mkIf config.dev.basic.enable {
      hm.home.packages = [pkgs.nix];

      hm.programs.direnv = {
        enable = true;
        config.global.warn_timeout = 0;
        nix-direnv.enable = true;
        silent = true;
      };

      core.impermanence.hm.directories = [".local/share/direnv/allow"];

      core.cleanup.script = "HOME=/home/noah ${lib.getExe pkgs.direnv} prune";
    };
  };
}
