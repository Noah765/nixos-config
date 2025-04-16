{
  lib,
  inputs,
  config,
  ...
}:
with lib; let
  cfg = config.core.nix;
in {
  options.core.nix.enable = mkEnableOption "a patched version of the Nix language and core settings required for Nix";

  config = mkIf cfg.enable {
    os.system.stateVersion = "24.11";
    hm.home.stateVersion = "24.11";

    os.nix = {
      settings.experimental-features = ["nix-command" "flakes"];
      channel.enable = false;
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    };

    nixpkgs.config.allowUnfree = true;
  };
}
