{
  inputs,
  ...
}:
{
  modules.home = {
    hyprland = {
      enable = true;

      monitor = [ ",preferred,auto,1.0" ];
    };

    stylix = {
      enable = true;

      image = inputs.wallpapers + "/gekkou_3840x2160.png";
    };
  };
}
