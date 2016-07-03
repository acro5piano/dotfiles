#!/bin/bash
for f in ~/.dotfiles/etc/service.d/*.service
do
    source "$f"
done
