{ pkgs, ... }:
{
  osImports = [ ./hardware-configuration.nix ];

  impermanence.disk = "nvme0n1";
  nvidia.enable = true;
  hyprland.enable = true;
  stylix.enable = true;

  os.environment.systemPackages = with pkgs; [
    neovim
    fzf
    nixfmt-rfc-style
  ];
}
