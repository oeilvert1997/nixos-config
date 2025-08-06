{
  inputs,
  self,
  ...
}:
let
  mkHomeConfiguration =
    {
      system,
      username,
      hostname,
      modules ? [ ],
      extraSpecialArgs ? { },
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        inputs.nixvim.homeModules.nixvim
        ../users/${username}/home.nix
        ../profiles/home/core.nix
      ]
      ++ modules;
      extraSpecialArgs = {
        inherit
          inputs
          self
          hostname
          username
          ;
      }
      // extraSpecialArgs;
    };
in
{
  flake.homeConfigurations = {
    "oeilvert@woglinde" = mkHomeConfiguration {
      system = "x86_64-linux";
      hostname = "woglinde";
      username = "oeilvert";
      modules = [
        inputs.niri.homeModules.niri
        inputs.nix-colors.homeManagerModules.default
        inputs.stylix.homeModules.stylix
        ../profiles/home/desktop.nix
      ];
    };

    "oeilvert@flosshilde" = mkHomeConfiguration {
      system = "x86_64-linux";
      hostname = "flosshilde";
      username = "oeilvert";
      modules = [
        inputs.niri.homeModules.niri
        inputs.nix-colors.homeManagerModules.default
        inputs.stylix.homeModules.stylix
        ../profiles/home/desktop.nix
      ];
    };

    "oeilvert@diva-00" = mkHomeConfiguration {
      system = "x86_64-linux";
      hostname = "diva-00";
      username = "oeilvert";
      modules = [
        inputs.nix-colors.homeManagerModules.default
        ../profiles/home/i3.nix
      ];
    };
  };
}
