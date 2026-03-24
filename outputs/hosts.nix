{ inputs, ... }:
let
  mkPi = modules: inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    inherit modules;
  };

  hosts = {
    cellar = mkPi [
      inputs.nixarr.nixosModules.default
      ../hosts/cellar/configuration.nix
    ];

    ward = mkPi [
      ../hosts/ward/configuration.nix
    ];
  };

in
{
  flake = {
    nixosConfigurations = hosts;
    packages.aarch64-linux = {
      cellar = hosts.cellar.config.system.build.sdImage;
      ward = hosts.ward.config.system.build.sdImage;
    };
  };
}
