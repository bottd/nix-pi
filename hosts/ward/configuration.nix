{ pkgs, ... }:
{
  imports = [ ../../modules/pi-base.nix ];

  networking = {
    hostName = "ward";
    firewall.allowedTCPPorts = [ 22 ];
  };

  environment.systemPackages = with pkgs; [
    htop
  ];
}
