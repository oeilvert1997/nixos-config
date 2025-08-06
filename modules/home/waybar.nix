_: {
  programs.waybar = {
    enable = true;

    settings = {
      primary = {
        layer = "top";
        output = [
          "*"
        ];
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "clock" ];

        "hyprland/workspaces" = { };
        clock = { };
      };
    };

    style = '''';
  };
}
