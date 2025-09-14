{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = { config, pkgs, ... }: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        nixpkgs-fmt.enable = true;
        deadnix = {
          enable = true;
          no-lambda-arg = true;
          no-lambda-pattern-names = true;
        };
        statix.enable = true;
      };
    };

    formatter = config.treefmt.build.wrapper;

    devShells.default = pkgs.mkShell {
      name = "nix-pi-dev";

      nativeBuildInputs = with pkgs; [
        config.treefmt.build.wrapper
        git
      ];
    };
  };
}
