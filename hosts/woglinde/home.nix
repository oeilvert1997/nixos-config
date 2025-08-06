{
  self,
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

      image = self + /assets/wallpapers/Gekkou_3840x2160.png;
    };
  };
}
