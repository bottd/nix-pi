{ pkgs, nixpkgs, lib, config, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    ./hardware-configuration.nix
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];



  config = {

    boot = {
      loader = { grub.enable = false; generic-extlinux-compatible.enable = true; };
      kernelPackages = pkgs.linuxPackages_latest;
      tmp.cleanOnBoot = true;
      initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" "pcie_brcmstb" ];
    };

    users.users.pi = { isNormalUser = true; extraGroups = [ "wheel" ]; };

    services = {
      openssh.enable = true;
      avahi = { enable = true; nssmdns4 = true; publish.enable = true; };
    };

    environment.systemPackages = with pkgs; [
      neovim
      git
      curl
      libraspberrypi
      raspberrypi-eeprom
    ];

    powerManagement.cpuFreqGovernor = "ondemand";

    swapDevices = [{ device = "/swapfile"; size = 2048; }];

    hardware = {
      firmware = with pkgs; [ linux-firmware wireless-regdb ];
      deviceTree = { enable = true; filter = "*rpi-4-*.dtb"; };
      bluetooth.enable = true;
    };

    # Set parameterized SD image filename based on hostname
    image.fileName = "${hostName}-pi.img";

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      };
      gc.automatic = true;
    };

    system.stateVersion = "25.05";
  };
}
