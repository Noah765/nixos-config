{
  lib,
  inputs,
  ...
}: {
  hosts.laptop.settings = {
    imports = [inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490];

    core = {
      impermanence.disk = "nvme0n1";
      keyboard.enable = true;
      networking.hostName = "laptop";
    };

    apps.steam.enable = true;
    apps.signal.enable = true;

    dev = {
      dart.enable = true;
      java.enable = true;
      nu.enable = true;
      rust.enable = true;
      typst.enable = true;
      verilog.enable = true;
    };
  };

  hosts.laptop.hardware = {
    modulesPath,
    config,
    ...
  }: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot.initrd = {
      availableKernelModules = ["nvme" "rtsx_pci_sdmmc" "xhci_pci"];
      kernelModules = ["dm-snapshot"];
    };
    boot.kernelModules = ["kvm-intel"];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
