{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/home";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

in
{
  imports = [
    ./common.nix
    ./claude.nix
  ];

  nixpkgs.config.allowUnfree = true;

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
    ".pi/agent/settings.json".source = link ".pi/agent/settings.json";
    ".pi/agent/skills".source = link ".pi/agent/skills";
    ".pi/agent/extensions".source = link ".pi/agent/extensions";
    ".pi/agent/prompts".source = link ".claude/commands";
  };

  xdg.configFile = {
    "alacritty".source = link ".config/alacritty";
    "fish/conf.d/wi.fish".source = link ".config/fish/conf.d/wi.fish";
    "fish/conf.d/cc-sessions.fish".source = link ".config/fish/conf.d/cc-sessions.fish";
    "fish/config.fish".source = link ".config/fish/config.fish";
    "gh/config.yml".source = link ".config/gh/config.yml";
    "herdr/config.toml".source = link ".config/herdr/config.toml";
    "i3status-rust".source = link ".config/i3status-rust";
    "mimeapps.list".source = link ".config/mimeapps.list";
    "mpv/mpv.conf".source = link ".config/mpv/mpv.conf";
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
    "opencode/commands".source = link ".claude/commands";
    "gtk-3.0/bookmarks".text = ''
        file://${config.home.homeDirectory}/Downloads
        file:///run/media/kazuya/1C79-7DB3/DCIM/100GOPRO/
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

  # Automount removable devices (USB sticks etc.) to /run/media/$USER/<label>
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true; # via dunst
    tray = "never"; # swaybar has no SNI tray host
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
