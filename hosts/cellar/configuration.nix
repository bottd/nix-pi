{
  imports = [ ../../modules/pi-base.nix ];

  networking.hostName = "cellar";

  services.syncthing = {
    enable = true;
    user = "pi";
    dataDir = "/home/pi/Sync";
    configDir = "/home/pi/.config/syncthing";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    settings.gui.theme = "default";
  };

  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };

  systemd.services.syncthing.serviceConfig = { MemoryMax = "512M"; CPUQuota = "75%"; };
}
