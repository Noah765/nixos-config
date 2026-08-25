{lib, ...}: {
  nixos = {config, ...}: {
    options.cli.proton-pass-cli.enable = lib.mkEnableOption "Proton Pass CLI";

    config = lib.mkIf config.cli.proton-pass-cli.enable {
      wrappers.proton-pass-cli.enable = true;
      core.impermanence.hm.directories = [".local/share/proton-pass-cli/.session"];
    };
  };

  flake.wrappers.proton-pass-cli = {pkgs, ...}: {
    imports = [lib.w.modules.default];
    package = pkgs.proton-pass-cli;
    env.PROTON_PASS_KEY_PROVIDER = "fs";
  };
}
