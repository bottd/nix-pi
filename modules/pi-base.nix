{ pkgs, nixpkgs, ... }:
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

  boot = {
    loader = { grub.enable = false; generic-extlinux-compatible.enable = true; };
    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [ "console=ttyS0,115200" "console=tty1" "cma=256M" ];
    tmp.cleanOnBoot = true;
    blacklistedKernelModules = [ "sun4i-drm" ];
    initrd.includeDefaultModules = false;
  };

  networking = {
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
  };

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.pi = {
    isNormalUser = true;
    home = "/home/pi";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ ];
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = { enable = true; addresses = true; };
    };
  };

  environment.systemPackages = with pkgs; [ vim git htop tmux curl ];

  powerManagement.cpuFreqGovernor = "ondemand";

  swapDevices = [{ device = "/swapfile"; size = 2048; }];

  hardware = {
    enableRedistributableFirmware = true;
    raspberry-pi."4" = { fkms-3d.enable = false; audio.enable = false; };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
    gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 30d"; };
  };

  system.stateVersion = "25.05";
}
