{ inputs, ... }:
let
  hosts = {
    cellar = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit (inputs) nixpkgs; };
      modules = [
        ../hosts/cellar/configuration.nix
      ];
    };

    ward = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit (inputs) nixpkgs; };
      modules = [
        ../hosts/ward/configuration.nix
      ];
    };
  };

in
{
  flake = {
    nixosConfigurations = hosts;
    packages.aarch64-linux = {
      cellar = hosts.cellar.config.system.build.sdImage;
      ward = hosts.ward.config.system.build.sdImage;
      default = hosts.cellar.config.system.build.sdImage;
    };
  };
}
