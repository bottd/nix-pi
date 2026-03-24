{ pkgs, config, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  fileSystems = {
    "/" = { device = "/dev/disk/by-label/NIXOS_SD"; fsType = "ext4"; };
    "/boot/firmware" = { device = "/dev/disk/by-label/FIRMWARE"; fsType = "vfat"; };
  };

  boot = {
    tmp.cleanOnBoot = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" "pcie_brcmstb" ];
  };

  hardware.deviceTree = {
    enable = true;
    filter = "*rpi-4-*.dtb";
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  zramSwap.enable = true;

  image.fileName = "${config.networking.hostName}-pi.img";

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    htop
    libraspberrypi
    raspberrypi-eeprom
  ];

  system.stateVersion = "25.05";
}
