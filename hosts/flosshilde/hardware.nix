{
  config,
  lib,
  ...
}:
{
  imports = [ ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      # "ahci"
      # "thunderbolt"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [
      "kvm-intel"
    ];
    extraModulePackages = [ ];

    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "pcie_ports=compat"
      "brcmfmac.feature_disable=0x82000"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
    options = [
      "noatime"
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@root"
      "compress=zstd:1"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd:1"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd:1"
      "noatime"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@swap"
      "noatime"
    ];
  };

  fileSystems."/snapshots" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@snapshots"
      "compress=zstd:1"
      "noatime"
    ];
  };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
