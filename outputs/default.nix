{ inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
    ./formatters.nix
    ./hosts.nix
  ];
}
