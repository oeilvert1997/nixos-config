{
  pkgs,
  ...
}:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --asterisks \
            --cmd Hyprland
        '';
        user = "greeter";
      };
    };
  };
}
