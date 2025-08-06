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
      extraSpecialArgs = { inherit inputs self username; } // extraSpecialArgs;
    };
in
{
  flake.homeConfigurations = {
    "oeilvert@woglinde" = mkHomeConfiguration {
      system = "x86_64-linux";
      username = "oeilvert";
      modules = [
        inputs.stylix.homeModules.stylix
        ../profiles/home/desktop.nix
      ];
    };

    "oeilvert@diva-00" = mkHomeConfiguration {
      system = "x86_64-linux";
      username = "oeilvert";
      modules = [
        ../profiles/home/i3.nix
      ];
    };
  };
}
