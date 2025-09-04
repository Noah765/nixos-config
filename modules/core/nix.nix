{
  lib,
  inputs,
  config,
  ...
}: {
  options.core.nix.enable = lib.mkEnableOption "the Nix language";

  config = lib.mkIf config.core.nix.enable {
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
