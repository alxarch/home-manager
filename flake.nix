{
  description = "Home Manager configuration of alxarch";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
        overlays = [ unstableOverlay ];
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations."alxarch@wsl" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./neovim.nix
          ./bash.nix
          ./git.nix
          ./tmux.nix
          ./ssh.nix
        ];
      };
      homeConfigurations."alxarch@archon" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./neovim.nix
          ./tmux.nix
          ./bash.nix
        ];
      };
    };
}
