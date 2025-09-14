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

  disabledModules = [
    "profiles/all-hardware.nix"
    "profiles/base.nix"
    "hardware/all-firmware.nix"
  ];

  options = {
    hardware.enableRedistributableFirmware = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    hardware.wirelessRegulatoryDatabase = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1";
        message = "Raspberry Pi 4 requires kernel version >= 6.1";
      }
    ];

    boot = {
      loader = { grub.enable = false; generic-extlinux-compatible.enable = true; };
      kernelPackages = pkgs.linuxPackages_rpi4;
      kernelParams = [ "console=ttyS0,115200" "console=tty1" "cma=256M" ];
      tmp.cleanOnBoot = true;
      initrd = {
        includeDefaultModules = false;
        kernelModules = lib.mkForce [ ];
        availableKernelModules = lib.mkForce [ "usbhid" "usb_storage" "vc4" "pcie_brcmstb" ];
      };
    };

    networking.interfaces.eth0.useDHCP = true;


    users.users.pi = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    services = {
      openssh.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
        publish.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [ vim git htop tmux curl ];

    powerManagement.cpuFreqGovernor = "ondemand";

    swapDevices = [{ device = "/swapfile"; size = 2048; }];

    hardware = {
      firmware = [ pkgs.linux-firmware ];
      deviceTree = {
        enable = true;
        filter = "*rpi-4-*.dtb";
      };
    };

    # Set parameterized SD image filename based on hostname
    sdImage.imageName = "${hostName}-pi.img";

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
