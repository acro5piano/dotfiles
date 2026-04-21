{ config, pkgs, username, ... }:

let
  toggl-cli = pkgs.stdenv.mkDerivation rec {
    pname = "toggl-cli";
    version = "latest";
    src = pkgs.fetchurl {
      url = "https://github.com/acro5piano/toggl-cli-rs/releases/latest/download/toggl-cli-rs";
      sha256 = "sha256-EJYN+J0Q+FOheQKZ9iATyHEF6T3lVkNQ4ZvimOcDksc=";
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

  dotfiles = "${config.home.homeDirectory}/.dotfiles/home";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

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
    ansible
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
    pgcli
    ripgrep
    rsync
    transcrypt
    tree
    unzip
    xh
    xremap
    zola
    zip

    # Development tools
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
    tree-sitter

    # Fonts
    ipaexfont
    noto-fonts
    noto-fonts-color-emoji
    source-code-pro

    # Desktop apps
    audacity
    clipman
    google-cloud-sdk
    libnotify
    toggl-cli
    dunst
    feh
    grim
    i3status-rust
    lxqt.pavucontrol-qt
    rofi
    slurp
    swaybg
    tigervnc
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
        "npm:@anthropic-ai/claude-code" = "2.1.112";
        "npm:@openai/codex" = "0.121.0";
        "npm:prettier" = "latest";
        "npm:pyright" = "latest";
        "npm:typescript" = "latest";
        "npm:typescript-language-server" = "latest";
        "npm:@astrojs/language-server" = "latest";
        "npm:snyk" = "latest";
        "npm:@googleworkspace/cli" = "latest";

        python = "latest";
        uv = "latest";
        pipx = "latest";
        "pipx:awscli" = "latest";
        "pipx:ipython" = "latest";
        "pipx:iredis" = "latest";
        "pipx:litecli" = "latest";
        "pipx:mycli" = "latest";
        "pipx:athenacli" = "latest";
        "pipx:virtualenv" = "latest";
        "pipx:markitdown[all]" = "latest";
      };
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
  };

  # Dotfiles from link.sh
  home.file = {
    "screenshots/.keep".text = "";
    "bin".source = link "bin";
    ".editorconfig".source = link ".editorconfig";
    ".gitconfig".source = link ".gitconfig";
    "prettier.config.js".source = link "prettier.config.js";
    ".ripgreprc".source = link ".ripgreprc";
    ".tmux.conf".source = link ".tmux.conf";
    ".emacs.d".source = link ".emacs.d";
    ".aider.conf.yml".source = link ".aider.conf.yml";
  };

  xdg.configFile = {
    "alacritty".source = link ".config/alacritty";
    "fish/conf.d/wi.fish".source = link ".config/fish/conf.d/wi.fish";
    "fish/config.fish".source = link ".config/fish/config.fish";
    "gh/config.yml".source = link ".config/gh/config.yml";
    "i3status-rust".source = link ".config/i3status-rust";
    "mimeapps.list".source = link ".config/mimeapps.list";
    "joplin-desktop/userchrome.css".source = link ".config/joplin-desktop/userchrome.css";
    "nvim/init.lua".source = link ".config/nvim/init.lua";
    "nvim/lua".source = link ".config/nvim/lua";
    "nvim/snippets".source = link ".config/nvim/snippets";
    "nvim/.luarc.json".source = link ".config/nvim/.luarc.json";
    "sway".source = link ".config/sway";
    "xremap".source = link ".config/xremap";
    "wireplumber".source = link ".config/wireplumber";
    "pipewire/pipewire.conf.d".source = link ".config/pipewire/pipewire.conf.d";
    "gtk-3.0/bookmarks".text = ''
        file://${config.home.homeDirectory}/Downloads
    '';
  };

  xdg.desktopEntries.brave-browser-x11 = {
    name = "Brave (X11)";
    genericName = "Web Browser";
    comment = "Access the Internet (X11 mode)";
    exec = "brave --ozone-platform=x11 %U";
    icon = "brave-desktop";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    startupNotify = true;
    settings.StartupWMClass = "brave-browser";
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
    actions = {
      new-window = { name = "New Window"; exec = "brave --ozone-platform=x11"; };
      new-private-window = { name = "New Incognito Window"; exec = "brave --ozone-platform=x11 --incognito"; };
    };
  };

  xdg.desktopEntries.chromium-x11 = {
    name = "Chromium (X11)";
    genericName = "Web Browser";
    comment = "Access the Internet (X11 mode)";
    exec = "/usr/bin/chromium --ozone-platform=x11 %U";
    icon = "chromium";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    startupNotify = true;
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
    actions = {
      new-window = { name = "New Window"; exec = "/usr/bin/chromium --ozone-platform=x11"; };
      new-private-window = { name = "New Incognito Window"; exec = "/usr/bin/chromium --ozone-platform=x11 --incognito"; };
    };
  };

  xdg.desktopEntries.joplin = {
    name = "Joplin";
    exec = "${config.home.homeDirectory}/.local/bin/joplin";
    icon = "joplin";
    comment = "An open source note taking and to-do application";
    categories = [ "Office" "TextEditor" "Utility" ];
    terminal = false;
  };

  # xremap systemd user service (started after sway via graphical-session.target)
  systemd.user.services.xremap = {
    Unit = {
      Description = "xremap keyboard remapper";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${xremap}/bin/xremap %h/.config/xremap/orz-layout.yml --watch";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
