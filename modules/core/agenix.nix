{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.core.agenix;
in {
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "nixpkgs";
        darwin.follows = "";
      };
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
      # TODO Override unused inputs
    };
  };

  # TODO Check if the default agenix module is actually required
  osImports = [inputs.agenix.nixosModules.default inputs.agenix-rekey.nixosModules.default];

  options.core.agenix.enable = mkEnableOption "agenix and agenix-rekey for secret management";

  config = mkIf cfg.enable {
    dependencies = ["core.yubikey"];

    hm.home.packages = [inputs.agenix-rekey.packages.${pkgs.system}.default];

    os.age.rekey = {
      masterIdentities = [
        (pkgs.writeText "yubikey-identity.pub" ''
          #       Serial: 17033108, Slot: 1
          #         Name: agenix
          #      Created: Sun, 06 Oct 2024 13:04:44 +0000
          #   PIN policy: Never  (A PIN is NOT required to decrypt)
          # Touch policy: Always (A physical touch is required for every decryption)
          #    Recipient: age1yubikey1qtdshrxfxl29zkwde694clxy9evzqweayyenfcqh3xr3hprc4djhgaak6rx
          AGE-PLUGIN-YUBIKEY-1JNNSXQVZLEQ635G0GXNHF
        '')
        .outPath
        # TODO Add a backup password identity
      ];

      # TODO Automatically generate ssh key in install script
      hostPubkey = "/etc/ssh/ssh_host_ed25519_key.pub";
    };
  };
}
