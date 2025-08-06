_: {
  programs.yazi = {
    enable = true;

    enableZshIntegration = true;

    shellWrapperName = "yy";

    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };
}
