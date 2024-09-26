#!/bin/bash

function link() {
	to=$HOME/$1
	if [ ! -e $from ]; then
		echo 'not found: ' $from
		return
	fi
	from=$HOME/.dotfiles/home/$1
	if [ ! -e $to ]; then
		ln -svf $from $to
	fi
}

link bin
link .config/alacritty
link .config/fish/conf.d/wi.fish
link .config/fish/config.fish
link .config/gh/config.yml
link .config/i3status-rust
link .config/joplin-desktop/userchrome.css
link .config/nvim
link .config/sway
link .editorconfig
link .gitconfig
link prettier.config.js
link .ripgreprc
link .tmux.conf
link .xremap
link .emacs.d

if [ -z $1 ]; then
    sudo rm -rf /etc/keyd && sudo ln -svf $HOME/.dotfiles/etc/keyd /etc/keyd
fi
