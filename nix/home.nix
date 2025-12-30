{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # User-level packages
  home.packages = with pkgs; [
    # CLI tools
    acpi
    bat
    delta
    dnsutils
    fd
    fzf
    gh
    ghostscript
    imagemagick
    jq
    light
    paru
    ripgrep
    rsync
    tree
    unzip
    xh
    zip

    # Development tools (moved from pacman)
    gfortran
    git
    gnumake
    lapack
    lua
    lua-language-server
    lynis
    openssl
    postgresql
    ruff
    rust-analyzer
    stylua
    terraform
    tmux

    # Fonts (from sway.yml)
    ipaexfont
    nerd-fonts.sauce-code-pro
    noto-fonts
    noto-fonts-color-emoji
    source-code-pro

    # Desktop apps
    audacity
    clipmenu
    ddcutil
    dunst
    feh
    grim
    i3status-rust
    lxqt.pavucontrol-qt
    pcmanfm
    qt6Packages.fcitx5-configtool
    rofi
    slurp
    swaybg
    wl-clipboard
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
        "npm:typescript" = "latest";
        "npm:typescript-language-server" = "latest";
        "npm:@astrojs/language-server" = "latest";

        python = "latest";
        # Python tools (from pip.yml)
        uv = "latest";
        "pipx:aider-install" = "latest";
        "pipx:awscli" = "latest";
        "pipx:ipython" = "latest";
        "pipx:iredis" = "latest";
        "pipx:litecli" = "latest";
        "pipx:mycli" = "latest";
        "pipx:pgcli" = "latest";
        "pipx:virtualenv" = "latest";
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
    ".emacs.d".source = ../home/.emacs.d;
    ".aider.conf.yml".source = ../home/.aider.conf.yml;
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
