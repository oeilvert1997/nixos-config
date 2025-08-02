{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.devshell.flakeModule
        inputs.treefmt-nix.flakeModule
        ./flake-parts/nixos-configurations.nix
        ./flake-parts/home-configurations.nix
        ./flake-parts/profiles.nix
        ./flake-parts/overlays.nix
        ./flake-parts/devshell.nix
        ./flake-parts/treefmt.nix
      ];

      flake = {
        nixosModules = {
          default = ./modules/nixos;
          profiles = ./profiles;
        };

        homeModules = {
          default = ./modules/home-manager;
          profiles = ./profiles/home;
        };
      };
    };
}
