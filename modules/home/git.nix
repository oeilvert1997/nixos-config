{
  username,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user.name = username;
      user.email = "${username}@nixos.com";

      core.editor = "nvim";
    };
  };
}
