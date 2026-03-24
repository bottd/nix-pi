_:
{
  imports = [
    ../../modules/pi4-hardware.nix
    ../../modules/nix-settings.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/poe-hat.nix
    ../../modules/storage.nix
  ];

  networking = {
    hostName = "cellar";
    interfaces.end0.ipv4.addresses = [{
      address = "192.168.1.10"; # TODO: adjust to your network
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1"; # TODO: adjust to your network
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  nixarr = {
    enable = true;
    mediaDir = "/mnt/storage/media";
    stateDir = "/mnt/storage/.state/nixarr";

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    transmission = {
      enable = true;
      openFirewall = true;
      # vpn.enable = true;
      # vpn.wgConf = "/data/.secret/wg.conf";
    };

    sonarr = {
      enable = true;
      openFirewall = true;
    };

    radarr = {
      enable = true;
      openFirewall = true;
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
    };

    bazarr = {
      enable = true;
      openFirewall = true;
    };
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/storage      192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)
      /mnt/storage/media 192.168.1.0/24(ro,sync,no_subtree_check)
    '';
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
  networking.firewall.allowedUDPPorts = [ 2049 ];

  services.syncthing = {
    enable = true;
    user = "pi";
    dataDir = "/mnt/storage/syncthing";
    configDir = "/mnt/storage/.state/syncthing";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
  };

  systemd.services.syncthing.serviceConfig = {
    MemoryMax = "256M";
    CPUQuota = "50%";
  };

  # Swap on SATA instead of SD card to reduce wear
  swapDevices = [{ device = "/mnt/storage/.swapfile"; size = 2048; }];
}
