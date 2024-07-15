{ pkgs, ... }:
{
  osImports = [ ./hardware-configuration.nix ];

  impermanence.disk = "nvme0n1";
  nvidia.enable = true;
  stylix.enable = true;
  sddm.enable = true;
  hyprland.enable = true;
  anyrun.enable = true;

  os.environment.systemPackages = with pkgs; [
    neovim
    fzf
    nixfmt-rfc-style
  ];
}
