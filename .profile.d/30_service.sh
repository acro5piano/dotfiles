#!/bin/bash

if [ -e "~/.dotfiles/etc/service.d/`hostname`/*.service" ]; then
    for f in ~/.dotfiles/etc/service.d/*.service
    do
        source "$f"
    done
fi

if [ -e "~/.dotfiles/etc/service.d/`hostname`/*.service" ]; then
    for f in ~/.dotfiles/etc/service.d/`hostname`/*.service
    do
        source "$f"
    done
fi
