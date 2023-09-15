{
  description = "Home Manager configuration of alxarch";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, nixpkgs-unstable, nixgl, ... }:
    let
      system = "x86_64-linux";
      unstableOverlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      wrapNixGLOverlay = final: prev: {
        wrapNixGL = ({ name, package, ... }: with final; symlinkJoin {
          name = name;
          paths = [
            (writeShellScriptBin name ''
              ${prev.nixgl.auto.nixGLDefault}/bin/nixGL ${package}/bin/${name} "$@"
            '')
            package
          ];
        });
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ unstableOverlay nixgl.overlay wrapNixGLOverlay ];
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations."alxarch" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
