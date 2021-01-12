#!/bin/bash

set -ue

sudo ln -svf $HOME/.dotfiles/etc/systemd/system/after-boot.service /etc/systemd/system/after-boot.service
sudo ln -svf $HOME/.dotfiles/etc/systemd/system/before-suspend.service /etc/systemd/system/before-suspend.service
sudo ln -svf $HOME/.dotfiles/etc/systemd/system/after-suspend.service /etc/systemd/system/after-suspend.service
sudo ln -svf $HOME/.dotfiles/etc/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d/40-libinput.conf

sudo systemctl enable after-boot.service
sudo systemctl enable before-suspend.service
sudo systemctl enable after-suspend.service
