{lib, ...}: {
  hosts.primary.settings = {
    core = {
      charachorder.enable = true;
      impermanence.disk = "nvme0n1";
      networking.hostName = "primary";
      nvidia.enable = true;
    };

    cli.installer.enable = true;

    desktop.hyprland.settings.monitor = ["DP-1, 1920x1080@144, 0x0, 1" "HDMI-A-1, 1920x1080@60, 1920x0, 1"];

    dev = {
      codex.enable = true;
      dart.enable = true;
      java.enable = true;
      nu.enable = true;
      qml.enable = true;
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
