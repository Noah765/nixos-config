{lib, ...}:
with lib; {
  imports = [
    ./installer.nix
    ./git.nix
    ./kitty.nix
    ./firefox.nix
    ./slack.nix
  ];

  git = {
    enable = mkDefault true;
    gitHub = mkDefault true;
  };
  kitty.enable = mkDefault true;
  firefox.enable = mkDefault true;
  slack.enable = mkDefault true;
}
