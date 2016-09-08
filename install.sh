#!/bin/bash
cd ~
git clone https://github.com/acro5piano/dotfiles $HOME/.dotfiles
$HOME/.dotfiles/bin/install_dotfiles
$HOME/.dotfiles/bin/install_vundle
vim -c VundleInstall

