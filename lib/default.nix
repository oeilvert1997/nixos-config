{
  lib,
  ...
}:

{
  scanNixFiles = path:
    lib.filter
      (file:
        (lib.strings.hasSuffix ".nix" file)
        && (lib.filesystem.baseNameOf file != "default.nix"))
      (lib.filesystem.listFilesRecursive path);
}
