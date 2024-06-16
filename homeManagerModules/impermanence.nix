{
  inputs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  options = {
    enable = mkEnableOption "impermanence";
    directories = { };
    files = { };
  };

  config = mkIf cfg.enable {
    home.persistence."/persist/home" = {
      allowOther = true;
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        # "VirtualBox VMs"
        ".gnupg"
        # ".ssh"
        # ".nixops"
        ".local/share/keyrings"
        ".local/share/direnv"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
      ] ++ cfg.directories;
      files = [ ".screenrc" ] ++ cfg.files;
    };
  };
}
