{
  hostname,
  self,
  ...
}:
{
  imports = [
    "${self}/hosts/${hostname}/home.nix"
  ];
}
