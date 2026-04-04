{
  lib,
  inputs,
  ...
}: {
  nixos = {config, ...}: {
    options.core.nix.enable = lib.mkEnableOption "the Nix language";

    config = lib.mkIf config.core.nix.enable {
      system.stateVersion = "26.05";
      hm.home.stateVersion = "26.05";

      nix = {
        settings.experimental-features = ["nix-command" "flakes"];
        channel.enable = false;
        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      };

      nixpkgs.config.allowUnfree = true;

      hm.programs.nh = {
        enable = true;
        flake = "/etc/nixos";
      };
    };
  };
}
