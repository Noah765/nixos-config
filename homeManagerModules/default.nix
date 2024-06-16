{ osConfig, lib, ... }:
with lib;
{
  imports = [ ./impermanence.nix ];

  impermanence.enable = mkIf osConfig.impermanence.enable (mkDefault true);
}
