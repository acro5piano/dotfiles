#!/bin/bash

# Configure system-wide config using root priviledge
# This is impossible using nix because I'm using arch linux rather than NixOS
set -euo pipefail

# ==============================================================================
# System packages (pacman)
# These require root or system-level integration
# ==============================================================================

# sudo pacman-key --populate archlinux
# sudo pacman-key --refresh-keys

SYSTEM_PACKAGES=(
    # Core system (require root or system-level integration)
    arch-install-scripts
    archlinux-keyring
    base
    base-devel
    brightnessctl
    chromium
    curl
    ddcutil
    fish
    lynis
    ntp
    openssh
    vim
    wget

    # Docker (daemon requires system integration)
    docker
    docker-compose

    # Desktop environment (Wayland/X11 require system integration)
    easyeffects
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
    xdg-desktop-portal-wlr
    fcitx5
    fcitx5-gtk
    fcitx5-mozc
    fcitx5-configtool

    # Outdated x11 things
    xorg-xinit
    xorg-xwayland
)

echo "Installing system packages..."
sudo pacman -S --needed --noconfirm "${SYSTEM_PACKAGES[@]}"

# ==============================================================================
# User and group configuration (from user.yml)
# ==============================================================================

echo "Configuring user and groups..."

# Ensure plugdev group exists
sudo groupadd -f plugdev

# Add user to required groups
sudo usermod -aG sys,docker,video,wheel,plugdev,input kazuya

# ==============================================================================
# System configuration files
# ==============================================================================

echo "Copying system configuration files..."

sudo cp -v ./etc/modules-load.d/uinput.conf /etc/modules-load.d/uinput.conf
sudo cp -v ./etc/modules-load.d/i2c_dev.conf /etc/modules-load.d/i2c_dev.conf
sudo cp -v ./etc/iwd/main.conf /etc/iwd/main.conf
sudo cp -v ./etc/systemd/network/20-wlan.network /etc/systemd/network/20-wlan.network

sudo localectl set-locale en_US.UTF-8
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules
echo uinput | sudo tee /etc/modules-load.d/uinput.conf

sudo systemctl enable --now docker

# ==============================================================================
# System configuration files for userland
# ==============================================================================

systemctl --user enable --now pipewire
systemctl --user enable --now wireplumber
systemctl --user enable --now pipewire-pulse

echo "Done! System configuration applied."
