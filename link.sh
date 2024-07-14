#!/bin/bash

function link() {
	to=$HOME/$1
	from=$HOME/.dotfiles/home/$1
	if [ ! -e $to ]; then
		ln -svf $from $to
	fi
}

link bin
link .config/alacritty
link .config/fish/config.fish
link .config/fish/wi.fish
link .config/nvim
link .config/sway
link .gitconfig
link .tmux.conf
link .xremap

# sudo ln -svf $HOME/.dotfiles/etc/keyd /etc/keyd

    # bin
    # .config/i3
    # .config/i3status-rust
    # .config/gh/config.yml
    # .editorconfig
    # .gitconfig
    # prettier.config.js
    # .ripgreprc
    # sql-formatter.json