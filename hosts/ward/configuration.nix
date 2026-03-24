_:
let
  dnsUpstreams = [ "1.1.1.1" "8.8.8.8" ];
in
{
  imports = [
    ../../modules/pi4-hardware.nix
    ../../modules/nix-settings.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/poe-hat.nix
  ];

  networking = {
    hostName = "ward";
    interfaces.end0.ipv4.addresses = [{
      address = "192.168.1.11"; # TODO: adjust to your network
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1"; # TODO: adjust to your network
    nameservers = dnsUpstreams;
    # adguardhome.openFirewall only covers the web UI, not DNS
    firewall.allowedTCPPorts = [ 53 ];
    firewall.allowedUDPPorts = [ 53 ];
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      http.address = "0.0.0.0:3000";
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
        upstream_dns = dnsUpstreams;
        bootstrap_dns = dnsUpstreams;
      };
    };
  };

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "default_config"
      "met"
      "esphome"
      "zeroconf"
    ];
    config = {
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "America/Chicago"; # TODO: adjust timezone
      };
      http.server_port = 8123;
    };
  };
}
