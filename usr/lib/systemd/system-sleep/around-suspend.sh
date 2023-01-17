#!/bin/bash

set -eux

if [ $1 == "pre" ]; then
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    systemctl restart iwd
    # sleep 5
    # systemctl restart xremap
    # sleep 3
    # xset r rate 230 60
fi
