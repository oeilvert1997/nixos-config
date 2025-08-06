{
  inputs,
  self,
  hostname,
  username,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "hm-backup";

    extraSpecialArgs = {
      inherit
        inputs
        self
        hostname
        username
        ;
    };

    sharedModules = [
      inputs.nixvim.homeModules.nixvim
    ];

    users.${username}.imports = [
      "${self}/profiles/home/core.nix"
    ];
  };
}
