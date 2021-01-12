#!/bin/bash

set -ue

DOTPATH="$HOME/.dotfiles"

ln -snvf $DOTPATH/bin $HOME/bin
ln -snvf $DOTPATH/.bash_profile $HOME/.bash_profile
ln -snvf $DOTPATH/.ctags $HOME/.ctags
ln -snvf $DOTPATH/.editorconfig $HOME/.editorconfig
ln -snvf $DOTPATH/.gemrc $HOME/.gemrc
ln -snvf $DOTPATH/.gitconfig $HOME/.gitconfig
ln -snvf $DOTPATH/prettier.config.js $HOME/prettier.config.js
ln -snvf $DOTPATH/.tmux.conf $HOME/.tmux.conf
ln -snvf $DOTPATH/.vim $HOME/.vim
ln -snvf $DOTPATH/.vimrc $HOME/.vimrc
ln -snvf $DOTPATH/.xinitrc $HOME/.xinitrc
ln -snvf $DOTPATH/.xinputrc $HOME/.xinputrc
ln -snvf $DOTPATH/.xmodmap $HOME/.xmodmap
ln -snvf $DOTPATH/.xremap $HOME/.xremap
ln -snvf $DOTPATH/.Xresources $HOME/.Xresources

ln -snvf $DOTPATH/.config $HOME/.config/awesome
ln -snvf $DOTPATH/.config/alacritty/ $HOME/.config/alacritty/
ln -snvf $DOTPATH/.config/awesome/ $HOME/.config/awesome/
ln -snvf $DOTPATH/.config/fish/ $HOME/.config/fish/
ln -snvf $DOTPATH/.config/nvim/ $HOME/.config/nvim/
ln -snvf $DOTPATH/.config/wallpapers/ $HOME/.config/wallpapers/
ln -snvf $DOTPATH/.config/flake8 $HOME/.config/flake8
