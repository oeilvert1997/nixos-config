{
  username,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user.name = username;
      user.email = "96994538+oeilvert1997@users.noreply.github.com";

      core.editor = "nvim";
    };
  };
}
