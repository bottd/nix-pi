{ pkgs, ... }:
{
  boot.initrd.availableKernelModules = [ "uas" "sd_mod" "ahci" ];

  # TODO: Update label once SATA adapter is connected (`lsblk` / `blkid`)
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-label/STORAGE";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  environment.systemPackages = with pkgs; [
    smartmontools
    hdparm
  ];
}
