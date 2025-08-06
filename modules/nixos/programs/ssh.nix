{
  self,
  lib,
  ...
}:
let
  hosts = builtins.attrNames (
    lib.filterAttrs (
      name: type: type == "directory" && builtins.pathExists "${self}/hosts/${name}/id_ed25519.pub"
    ) (builtins.readDir "${self}/hosts")
  );
in
{
  programs.ssh = {
    knownHosts = {
      github = {
        hostNames = [
          "github.com"
        ];

        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    }
    // lib.genAttrs hosts (host: {
      hostNames = [ host ];
      publicKeyFile = "${self}/hosts/${host}/id_ed25519.pub";
    });
  };
}
