{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Packages from yay.yml
  home.packages = with pkgs; [
    brave
    chromium
    delta
    fzf
    ipaexfont
    ripgrep
    rust-analyzer
    ruff
    stylua
    terraform
  ];

  # mise (runtime version manager)
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = "24";
        pnpm = "latest";
        rust = "stable";
        "npm:@anthropic-ai/claude-code" = "2.0.59";
        "npm:prettier" = "latest";
        "npm:pyright" = "latest";
        "npm:typescript-language-server" = "latest";
        "npm:@astrojs/language-server" = "latest";
        "ubi:LuaLS/lua-language-server" = "latest";
      };
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Dotfiles from link.sh
  home.file = {
    "bin".source = ../home/bin;
    ".editorconfig".source = ../home/.editorconfig;
    ".gitconfig".source = ../home/.gitconfig;
    "prettier.config.js".source = ../home/prettier.config.js;
    ".ripgreprc".source = ../home/.ripgreprc;
    ".tmux.conf".source = ../home/.tmux.conf;
    ".xremap".source = ../home/.xremap;
    ".emacs.d".source = ../home/.emacs.d;
    ".aider.conf.yml".source = ../home/.aider.conf.yml;
    ".simple-x11-remapper.yaml".source = ../home/.simple-x11-remapper.yaml;
  };

  xdg.configFile = {
    "alacritty".source = ../home/.config/alacritty;
    "fish/conf.d/wi.fish".source = ../home/.config/fish/conf.d/wi.fish;
    "fish/config.fish".source = ../home/.config/fish/config.fish;
    "gh/config.yml".source = ../home/.config/gh/config.yml;
    "i3status-rust".source = ../home/.config/i3status-rust;
    "mimeapps.list".source = ../home/.config/mimeapps.list;
    "joplin-desktop/userchrome.css".source = ../home/.config/joplin-desktop/userchrome.css;
    "nvim".source = ../home/.config/nvim;
    "sway".source = ../home/.config/sway;
  };
}
