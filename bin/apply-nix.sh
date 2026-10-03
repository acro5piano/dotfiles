#!/bin/bash
# Install user tools via Nix (home-manager)
#
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"


echo "==> Applying home-manager configuration..."
cd "$DOTFILES_DIR"
home-manager switch --flake .

echo "==> Installing devtools using mise..."
mise install

# Clone private repositories
repos=(
    "acro5piano/dotfiles-private"
    "acro5piano/daily-ai"
)
for repo in "${repos[@]}"; do
    dest="$HOME/ghq/github.com/$repo"
    if [ ! -d "$dest" ]; then
        echo "==> Cloning $repo..."
        mkdir -p "$(dirname "$dest")"
        git clone "git@github.com:$repo.git" "$dest"
    fi
done

# Managing joplin with Nix makes filesystem trouble, so we use simple curl script here
if [ ! -e ~/.local/bin/joplin ]; then
    echo "==> Installing joplin noteapp custom fork..."
    mkdir -p ~/.local/bin
    curl -L https://github.com/acro5piano/joplin-no-menubar/releases/download/no-menubar-35956061563-1/Joplin-3.7.18.AppImage > ~/.local/bin/joplin
    chmod +x ~/.local/bin/joplin
fi

echo "==> Creating lazy-lock.json symlink..."
ln -svf $PWD/home/.config/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.json

echo "==> Done."
