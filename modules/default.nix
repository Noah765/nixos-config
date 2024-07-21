{lib, ...}:
with lib; {
  imports = [
    ./core
    ./zsh.nix
    ./localization.nix
    ./docs.nix
    ./git.nix
    ./installer.nix
    ./stylix.nix
    ./sddm.nix
    ./hyprland.nix
    ./walker.nix
    ./apps
  ];

  os.system.stateVersion = "24.11";
  hm.home.stateVersion = "24.11";

  hmUsername = "noah";

  zsh.enable = mkDefault true;
  localization.enable = mkDefault true;
  docs.enable = mkDefault true;
  git = {
    enable = mkDefault true;
    gitHub = mkDefault true;
  };
}
