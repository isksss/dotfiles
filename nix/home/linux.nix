{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
  };

  home.file.".config/zsh/.zshrc".source = ../../home/dot_config/zsh/dot_zshrc;
}
