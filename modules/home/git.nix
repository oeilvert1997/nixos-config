{
  username,
  ...
}:
{
  programs.git = {
    enable = true;

    userName = username;
    userEmail = "${username}@nixos.com";
  };
}
