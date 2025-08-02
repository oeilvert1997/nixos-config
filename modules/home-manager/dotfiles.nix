_:
let
  configPath = ../../config;
in
{
  home.file.".gitconfig".source = "${configPath}/git/gitconfig";
}
