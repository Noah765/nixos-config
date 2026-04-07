{
  lib,
  inputs,
  ...
}: {
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
      system.stateVersion = "26.05";
      hm.home = {
        stateVersion = "26.05";

        packages = lib.mkIf config.core.nix.nom.enable [pkgs.nix-output-monitor];
      };

      nix = {
        settings.experimental-features = ["nix-command" "flakes"];
        channel.enable = false;
        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      };

      nixpkgs.config.allowUnfree = true;

      hm.programs.nh = {
        inherit (config.core.nix.nh) enable;
        flake = "/etc/nixos";
      };
    };
  };
}
