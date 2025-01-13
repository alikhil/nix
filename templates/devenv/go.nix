{ pkgs, ... }:

# See full reference at https://devenv.sh/reference/options/
{
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.pre-commit
    pkgs.gopls
    pkgs.godef
    pkgs.go-outline
  ];
  # https://devenv.sh/languages/
  languages.go = {
    enable = true;
    enableHardeningWorkaround = true;
  };
}
