_: {
  programs.quickshell = {
    enable = true;

    activeConfig = null;

    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
}
