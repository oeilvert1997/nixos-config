{
  inputs,
  ...
}:
let
  customScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha // {
    slug = "";
    name = "";
    author = "";
    palette = {
      # base00 = "";
      # base01 = "";
      # base02 = "";
      # base03 = "";
      # base04 = "";
      # base05 = "";
      # base06 = "";
      # base07 = "";
      # base08 = "";
      # base09 = "";
      # base0A = "";
      # base0B = "";
      # base0C = "";
      # base0D = "";
      # base0E = "";
      # base0F = "";
    };
  };
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = customScheme;
}
