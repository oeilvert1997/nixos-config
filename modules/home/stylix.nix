{
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";

    polarity = "dark";

    override = {
      base05 = "ffffff";
      base06 = "ffffff";
      base07 = "ffffff";
    };

    fonts.sizes = {
      terminal = 11;
    };
  };
}
