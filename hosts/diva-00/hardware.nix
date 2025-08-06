{
  lib,
  ...
}:
{
  imports = [ ];

  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "ahci"
      "ohci_pci"
      "ehci_pci"
      "sd_mod"
      "sr_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
    options = [
      "noatime"
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
}
