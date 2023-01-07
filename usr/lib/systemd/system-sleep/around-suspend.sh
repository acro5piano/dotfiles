#!/bin/bash

set -eux

if [ $1 == "pre" ]; then
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    systemctl restart iwd
fi
