#!/bin/bash

# Configure system-wide config using root priviledge
# This is impossible using nix because I'm using arch linux rather than NixOS
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
source "$DOTFILES_DIR/bin/packages.sh"

# ==============================================================================
# Packages (pacman)
# ==============================================================================

# sudo pacman-key --populate archlinux
# sudo pacman-key --refresh-keys

echo "Installing packages..."
sudo pacman -S --needed --noconfirm "${SYSTEM_PACKAGES[@]}" "${USER_PACKAGES[@]}"

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
sudo cp -v ./usr/lib/systemd/system-sleep/around-suspend.sh /usr/lib/systemd/system-sleep/around-suspend.sh

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

# ==============================================================================
# Drift check
#
# pacman has no equivalent of `home-manager switch`: deleting a line from
# packages.sh does not uninstall anything. Remember what we declared last time
# so that a package dropped from the lists gets reported instead of silently
# living on forever.
# ==============================================================================

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/pacman-managed.txt"
mkdir -p "$(dirname "$STATE_FILE")"

declared="$(printf '%s\n' "${SYSTEM_PACKAGES[@]}" "${USER_PACKAGES[@]}" "${AUR_PACKAGES[@]}" | sort -u)"

if [ -f "$STATE_FILE" ]; then
    dropped="$(comm -23 "$STATE_FILE" <(printf '%s\n' "$declared") | grep -xFf <(pacman -Qqe) || true)"
    if [ -n "$dropped" ]; then
        echo
        echo "==> WARNING: dropped from packages.sh but still installed:"
        printf '      %s\n' $dropped
        echo "    Remove them with:"
        echo "      sudo pacman -Rns $(echo $dropped | tr '\n' ' ')"
        echo
    fi
fi

printf '%s\n' "$declared" > "$STATE_FILE"

echo "Done! System configuration applied."
