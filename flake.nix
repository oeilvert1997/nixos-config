{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }:

  let
    inherit (inputs.nixpkgs) lib;
    system = "x86_64-linux";
    username = "oeilvert";
    mylib = import ./lib/default.nix { inherit lib; };
    specialArgs = {
      inherit inputs;
      inherit mylib;
    };
  in {
    nixosConfigurations = {
      diva-00 = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          ./hosts/vm-diva-00
          ./modules/system/desktop
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/desktop;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
      flosshilde = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          ./hosts/flosshilde
          ./modules/system/desktop
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/desktop;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };
  };
}
