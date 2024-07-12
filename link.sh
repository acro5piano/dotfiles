#!/bin/bash

ln -svf $HOME/.dotfiles/home/.config/nvim $HOME/.config/nvim
ln -svf $HOME/.dotfiles/home/.config/sway $HOME/.config/sway
ln -svf $HOME/.dotfiles/home/.xremap $HOME/.xremap
ln -svf $HOME/.dotfiles/home/.tmux.conf $HOME/.tmux.conf
ln -svf $HOME/.dotfiles/home/.config/fish/config.fish $HOME/.config/fish/config.fish
ln -svf $HOME/.dotfiles/home/.config/alacritty $HOME/.config/alacritty
ln -svf $HOME/.dotfiles/home/.gitconfig $HOME/.gitconfig

sudo ln -svf $HOME/.dotfiles/etc/keyd /etc/keyd

    # bin
    # .config/i3
    # .config/i3status-rust
    # .config/gh/config.yml
    # .editorconfig
    # .gitconfig
    # prettier.config.js
    # .ripgreprc
    # sql-formatter.json
