{ lib, ... }:
{
  fileSystems = {
    "/" = { device = "/dev/disk/by-label/NIXOS_SD"; fsType = "ext4"; };
    "/boot/firmware" = { device = "/dev/disk/by-label/FIRMWARE"; fsType = "vfat"; };
  };

  swapDevices = [ ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "conservative";
  networking.useDHCP = lib.mkDefault true;
}
