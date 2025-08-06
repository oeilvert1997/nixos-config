_: {
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;
      settings = {
        "general.autoScroll" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.startup.page" = 3;
        "sidebar.verticalTabs" = true;
        "signon.rememberSignons" = false;
      };
    };
  };
}
