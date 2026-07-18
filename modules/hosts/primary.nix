{lib, ...}: {
  hosts.primary.settings = {
    core = {
      charachorder.enable = true;
      impermanence.disk = "nvme-CT1000P1SSD8_2026292B60BD";
      networking.hostName = "primary";
      nvidia.enable = true;
    };

    dev = {
      codex.enable = true;
      dart.enable = true;
      java.enable = true;
      rust.enable = true;
      typst.enable = true;
    };

    apps.slack.enable = true;
    apps.steam.enable = true;
  };

  hosts.primary.hardware = {
    modulesPath,
    config,
    ...
  }: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot.initrd = {
      availableKernelModules = ["ahci" "nvme" "xhci_pci"];
      kernelModules = ["dm-snapshot"];
    };
    boot.kernelModules = ["kvm-amd"];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
