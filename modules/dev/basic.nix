{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.basic.enable = lib.mkEnableOption "basic development tools";

  config = lib.mkIf config.dev.basic.enable {
    hm.home.packages = [pkgs.nix];
    hm.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    # TODO automatically collect garbage using direnv prune
    core.impermanence.hm.directories = [".local/share/direnv/allow"];
  };
}
