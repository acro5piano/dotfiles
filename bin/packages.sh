#!/bin/bash
# Declarative pacman / AUR package lists.
#
# Sourced by apply-etc.sh and apply-aur.sh. Kept in one file so that the drift
# check in apply-etc.sh can see every package we claim to manage.
#
# Policy (see AGENTS.md):
#   - Anything in the Arch repos or the AUR is installed here, not with Nix.
#   - Nix (nix/home.nix) is for configuration, plus the few packages Arch does
#     not carry at all.

# ------------------------------------------------------------------------------
# System packages: require root, hardware access, or system-level integration
# ------------------------------------------------------------------------------
SYSTEM_PACKAGES=(
    # Core system
    arch-install-scripts
    archlinux-keyring
    base
    base-devel
    brightnessctl
    curl
    ddcutil
    ntp
    openssh
    vim
    wget

    # Not core, but requires root or system-wide install
    chromium
    fish
    lynis
    libmtp # To copy files from Android
    gvfs-mtp

    # Docker (daemon requires system integration)
    docker
    docker-compose

    # Desktop environment (Wayland/X11 require system integration)
    fuse2
    pavucontrol-qt
    pipewire
    pipewire-alsa
    pipewire-pulse
    portaudio
    noise-suppression-for-voice
    sway
    wireplumber
    polkit
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    fcitx5
    fcitx5-gtk
    fcitx5-mozc
    fcitx5-configtool
    mpv
    thunar
    thunar-volman
    tumbler

    # Outdated x11 things
    xorg-xinit
    xorg-xwayland
)

# ------------------------------------------------------------------------------
# User packages: no root needed, but Arch packages them and integrates them with
# the session (fontconfig, dbus, xdg-portals, GPU) better than nixpkgs can on a
# non-NixOS host.
# ------------------------------------------------------------------------------
USER_PACKAGES=(
    # Desktop apps / anything that draws, notifies, or talks to the compositor
    audacity
    dunst
    feh
    ghostscript
    grim
    i3status-rust
    imagemagick
    libnotify
    rofi
    slurp
    swaybg
    tigervnc
    wl-clipboard

    # Fonts (fontconfig integration is the reason these are not in Nix)
    adobe-source-code-pro-fonts # source-code-pro
    noto-fonts
    noto-fonts-emoji
    otf-ipaexfont

    # CLI tools
    acpi
    ansible
    bat
    bind # dig, nslookup (was dnsutils in nixpkgs)
    csvlens
    fd
    fzf
    git
    git-delta # delta
    github-cli # gh
    gost
    htmlq
    jq
    pgcli
    postgresql-libs # psql and friends, without the server
    ripgrep
    rsync
    tree
    unzip
    xh
    zip
    zola

    # Development tools
    gcc-fortran # gfortran
    lapack
    lua
    lua-language-server
    make # gnumake
    openssl
    ruff
    rust-analyzer
    stylua
    terraform
    tmux
    tree-sitter-cli # tree-sitter
)

# ------------------------------------------------------------------------------
# AUR packages
# ------------------------------------------------------------------------------
AUR_PACKAGES=(
    brave-bin
    paru-bin
)
