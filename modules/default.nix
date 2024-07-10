{ lib, ... }:
with lib;
{
  imports = [ ./impermanence.nix ];

  # Read the docs before changing
  #os.system.stateVersion = "23.11";
  hm.home.stateVersion = "24.11";

  hmUsername = "noah";

  impermanence.enable = mkDefault true;
}
