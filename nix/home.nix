{ config, pkgs, username, ... }:

let
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
    bat
    csvlens
    delta
    dnsutils
    fd
    fzf
    gh
    ghostscript
    google-cloud-sdk
    gost
    htmlq
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
    zip
    zola

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
    dunst
    feh
    grim
    i3status-rust
    libnotify
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
        rust = "stable";
        "npm:pnpm" = "10.34.1"; # To prevent mise ERROR Failed to install aqua:pnpm/pnpm@latest: no asset found: pnpm-linux-x64
        "npm:@anthropic-ai/claude-code" = "2.1.216";
        "npm:@openai/codex" = "0.130.0";
        "npm:prettier" = "latest";
        "npm:pyright" = "latest";
        "npm:typescript" = "latest";
        "npm:typescript-language-server" = "latest";
        "npm:@astrojs/language-server" = "latest";
        "npm:snyk" = "latest";
        "npm:@earendil-works/pi-coding-agent" = "0.75.5";
        "npm:opencode-ai" = "1.17.8";

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

        "http:pinact" = {
          version = "4.0.0";
          url = "https://github.com/suzuki-shunsuke/pinact/releases/download/v4.0.0/pinact_linux_amd64.tar.gz";
          sha256 = "f8ce19b1f85c9754482e1e95d6344727a99d0362cb53860c688b540183034623";
        };

        "http:toggl" = {
          version = "0.1.6";
          url = "https://github.com/acro5piano/toggl-cli-rs/releases/download/v0.1.6/toggl-cli-rs";
          sha256 = "10960df89d10f853a1790299f62013c87105e93de5564350e19be298e70392c7";
          bin = "toggl";
        };

        "http:clipman" = {
          version = "1.6.2";
          url = "https://github.com/acro5piano/clipman/releases/download/1.6.2/clipman";
          sha256 = "bfa8e0fb4ec9c58185a9259089060dd610ec7a841f73b1fc82d70d1750c1e6ca";
        };

        "http:xremap" = {
          version = "0.14.8";
          url = "https://github.com/xremap/xremap/releases/download/v0.14.8/xremap-linux-x86_64-wlroots.zip";
          sha256 = "d405dde9bc66c57f43e23c0aee3da03b0e938fa9586517b3a4a380a7579092d5";
        };

        "http:gitleaks" = {
          version = "8.30.1";
          url = "https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz";
        };
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
    ".pi/agent/keybindings.json".source = link ".pi/agent/keybindings.json";
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
    "opencode/tui.json".source = link ".config/opencode/tui.json";
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
      ExecStart = "%h/.local/share/mise/shims/xremap %h/.config/xremap/orz-layout.yml --watch";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
