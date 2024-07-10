{ inputs, pkgs, ... }:
{
  osImports = [ ./hardware-configuration.nix ];

  impermanence.disk = "nvme0n1";
  #impermanence.os.directories = ["test"];
  #nvidia.enable = true;
  # TODO homeManager.module = ./home.nix;
  #hyprland.enable = true;

  os.environment.systemPackages = with pkgs; [
    neovim
    fzf
    nixfmt-rfc-style
  ];
}
