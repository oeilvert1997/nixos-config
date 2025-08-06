{
  self,
  username,
  ...
}:
{
  imports = [
  ];

  home-manager.users.${username}.imports = [
    "${self}/profiles/home/server.nix"
  ];
}
