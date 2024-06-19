{
  inputs,
  osConfig,
  lib,
  options,
  config,
  ...
}:
with lib;
let
  cfg = config.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  options.impermanence =
    let
      persistenceOptions = options.home.persistence.type.getSubOptions [ ];
    in
    {
      enable = mkEnableOption "impermanence";
      directories = persistenceOptions.directories;
      files = persistenceOptions.files;
    };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.impermanence.enable;
        message = "The NixOS impermanence module is required for the home manager impermanence module.";
      }
    ];

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
