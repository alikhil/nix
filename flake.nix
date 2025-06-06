{
  description = "alikhil Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Because firefox is broken on mac
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nur.url = "github:nix-community/NUR";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-stable, nix-homebrew, homebrew-core, homebrew-cask, home-manager, nur, nixpkgs-firefox-darwin, ... }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mini
      darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./home/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alikkhilazhev = import ./home/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "alikkhilazhev";

              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
        ];
        inputs = { inherit nix-darwin nixpkgs-stable; };
      };

      # Expose the package set, including overlays, for convenience.
      # darwinPackages = self.darwinConfigurations."mini".pkgs;
      darwinConfigurations."VDF4JP6D5V" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./work/darwin.nix
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
              nixpkgs-firefox-darwin.overlay
              nur.overlays.default
            ];
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."a.khilazhev" = import ./work/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "a.khilazhev";

              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              # Automatically migrate existing Homebrew installations
              # autoMigrate = true;
            };
          }
        ];
        inputs = { inherit nix-darwin nixpkgs-stable; };
      };

      darwinPackages = self.darwinConfigurations."VDF4JP6D5V".pkgs + self.darwinConfigurations."mini".pkgs;
    };
}
