{lib, ...}: {
  debug = true;

  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.core.nix = {
      enable = lib.mkEnableOption "the Nix language";
      nh.enable = lib.mkEnableOption "nh" // {default = true;};
      nom.enable = lib.mkEnableOption "nix-output-monitor" // {default = true;};
    };

    config = lib.mkIf config.core.nix.enable {
      system.stateVersion = "26.11";
      hm.home.stateVersion = "26.11";

      hm.home.packages = lib.mkIf config.core.nix.nom.enable [pkgs.nix-output-monitor];

      nix.channel.enable = false;

      nix.settings = {
        auto-optimise-store = true;
        experimental-features = ["flakes" "nix-command"];
        flake-registry = "";
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        warn-dirty = false;
      };

      nixpkgs.config.allowUnfree = true;

      core.cleanup.script = "${lib.getExe pkgs.nh} clean all --keep 3 --keep-since 7d --keep-one";

      programs.nh = {
        inherit (config.core.nix.nh) enable;
        flake = "/etc/nixos";
      };
    };
  };
}
