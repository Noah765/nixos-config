{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.core.nix.enable = lib.mkEnableOption "the Nix language";

    config = lib.mkIf config.core.nix.enable {
      nix.channel.enable = false;

      nix.settings = {
        auto-optimise-store = true;
        experimental-features = ["flakes" "nix-command"];
        flake-registry = "";
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        warn-dirty = false;
      };

      core.cleanup.script = "${lib.getExe pkgs.nh} clean all --keep 3 --keep-since 7d --keep-one";
    };
  };
}
