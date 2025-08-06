{
  inputs,
  ...
}:
let
  useMyColor = true;

  flavor = {
    slug = "flavor";
    name = "flavor";
    author = "oeilvert";
    variant = "dark";

    palette = {
      base00 = "191b29";
      base01 = "1e2030";
      base02 = "2f334d";
      base03 = "636da6";
      base04 = "828bb8";
      base05 = "c8d3f5";
      base06 = "dde4ff";
      base07 = "f8f9ff";

      base08 = "ff757f";
      base09 = "ff966c";
      base0A = "ffc777";
      base0B = "c3e88d";
      base0C = "86e1fc";
      base0D = "82aaff";
      base0E = "c099ff";
      base0F = "fca7ea";
    };
  };
in
{
  colorScheme = if useMyColor then flavor else inputs.nix-colors.colorSchemes.tokyo-night-dark;
}
