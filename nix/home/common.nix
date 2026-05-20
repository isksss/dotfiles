{ config, pkgs, lib, isWSL ? false, ... }:
{
  home.stateVersion = "24.11";

  home.sessionVariables = {
    LANG = "ja_JP.UTF-8";
    LC_ALL = "ja_JP.UTF-8";
    EDITOR = "nvim";
    PAGER = "bat";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    STARSHIP_CONFIG = "${config.home.homeDirectory}/.config/starship.toml";
    ZDOTDIR = "${config.home.homeDirectory}/.config/zsh";
  };

  home.packages = with pkgs; [
    usage
    fzf
    ghq
    eza
    bat
    ripgrep
    delta
    starship
    neovim
    lazygit
    zellij
    atuin
    shfmt
    go
    nodejs_24
    deno
    glab
    gh
    zoxide
  ] ++ lib.optionals (!isWSL) [ ];

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.atuin.enable = true;

  home.file = {
    ".config/nvim".source = ../../home/dot_config/nvim;
    ".config/lazygit/config.yml".source = ../../home/dot_config/lazygit/config.yml;
    ".config/zellij/config.kdl".source = ../../home/dot_config/zellij/config.kdl;
    ".config/starship.toml".source = ../../home/dot_config/starship.toml;
    ".config/alacritty/alacritty.toml".source = ../../home/dot_config/alacritty/alacritty.toml;
    ".config/git/ignore".source = ../../home/dot_config/git/ignore;
    ".config/ghq/config.yml".source = ../../home/dot_config/ghq/config.yml;
    ".config/gwq/config.toml".source = ../../home/dot_config/gwq/config.toml;
    ".config/atuin/config.toml".source = ../../home/dot_config/atuin/config.toml;
    ".config/zsh/.zprofile".source = ../../home/dot_config/zsh/dot_zprofile;
    ".config/zsh/statusline.zsh".source = ../../home/dot_config/zsh/statusline.zsh;
    ".bashrc".source = ../../home/dot_bashrc;
    ".zshenv".source = ../../home/dot_zshenv;
    ".vimrc".source = ../../home/dot_vimrc;
  };
}
