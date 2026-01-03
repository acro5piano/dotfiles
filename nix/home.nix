{ config, pkgs, username, ... }:

let
  toggl-cli = pkgs.stdenv.mkDerivation rec {
    pname = "toggl-cli";
    version = "latest";
    src = pkgs.fetchurl {
      url = "https://github.com/acro5piano/toggl-cli-rs/releases/latest/download/toggl-cli-rs";
      sha256 = "sha256-4nEzLWg1obU13nXmInIURdiOcWPkKN6KUUI/YJGwL58=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/toggl
      chmod +x $out/bin/toggl
    '';
  };

  clipman = pkgs.stdenv.mkDerivation rec {
    pname = "clipman";
    version = "1.6.2";
    src = pkgs.fetchurl {
      url = "https://github.com/acro5piano/clipman/releases/download/${version}/clipman";
      sha256 = "sha256-v6jg+07JxYGFqSWQiQYN1hDseoQfc7H8gtcNF1DB5so=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/clipman
      chmod +x $out/bin/clipman
    '';
  };

  xremap = pkgs.stdenv.mkDerivation rec {
    pname = "xremap";
    version = "v0.14.8";
    src = pkgs.fetchurl {
      url = "https://github.com/xremap/xremap/releases/download/${version}/xremap-linux-x86_64-wlroots.zip";
      sha256 = "sha256-1AXd6bxmxX9D4jwK7j2gOw6Tj6lYZRezpKOAp1eQktU=";
    };
    nativeBuildInputs = [ pkgs.unzip ];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/bin
      cp xremap $out/bin/xremap
      chmod +x $out/bin/xremap
    '';
  };

  joplin = pkgs.appimageTools.wrapType2 {
    pname = "joplin";
    version = "3.5.9";
    src = pkgs.fetchurl {
      url = "https://github.com/acro5piano/joplin/releases/download/v3.5.9@no-menubar/Joplin-3.5.9.AppImage";
      sha256 = "sha256-5TbJyonLBkAfMVaVp6jN5jJmrb26ZtR2VOPPFraSPK8=";
    };
  };

in
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
    aider-chat
    bat
    delta
    dnsutils
    fd
    fzf
    gh
    ghostscript
    imagemagick
    jq
    paru
    ripgrep
    rsync
    transcrypt
    tree
    unzip
    xh
    xremap
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
    clipman
    google-cloud-sdk
    joplin
    libnotify
    toggl-cli
    dunst
    feh
    grim
    i3status-rust
    lxqt.pavucontrol-qt
    pcmanfm
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
        node = ["24" "22"];
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

  xdg.desktopEntries.joplin = {
    name = "Joplin";
    exec = "${joplin}/bin/joplin";
    icon = "joplin";
    comment = "An open source note taking and to-do application";
    categories = [ "Office" "TextEditor" "Utility" ];
    terminal = false;
  };
}
