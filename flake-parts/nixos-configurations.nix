{
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      mkSystem =
        hostname: system: profile:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname profile; };
          modules = [
            ../hosts/${hostname}/configuration.nix
            ../profiles/nixos/${profile}.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs hostname profile; };
                users.root = import ../profiles/home/admin.nix;
              };
            }
          ];
        };
    in
    {
      diva-00 = mkSystem "diva-00" "x86_64-linux" "server-test";
    };
}
