{
  description = "Home Manager configuration of alxarch";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
      homeConfigurations."alxarch@archon" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./neovim.nix
          ./tmux.nix
          ./bash.nix
        ];
      };
      homeConfigurations."alxarch@darktemplar" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          ./bash.nix
          ./tmux.nix
          ./kitty.nix
          ./neovim.nix
          {
            home.packages = with pkgs; [
              # Slack with GL support
              (wrapNixGL {
                name = "slack";
                package = unstable.slack;
              })
              # # Blender with GL support
              # (wrapNixGL {
              #   name = "blender";
              #   package = unstable.blender;
              # })
            ];
          }
        ];
      };
    };
}
