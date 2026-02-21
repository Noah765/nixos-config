{lib, ...}: {
  nixos = {config, ...}: {
    options.dev.codex.enable = lib.mkEnableOption "Codex";

    config = lib.mkIf config.dev.codex.enable {
      hm.programs.codex.enable = true;
      core.impermanence.hm.directories = [".codex"];
    };
  };
}
