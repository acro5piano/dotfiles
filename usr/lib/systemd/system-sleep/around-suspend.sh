#!/bin/bash

set -eu

if [ $1 == "pre" ]; then
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    systemctl restart iwd
    sleep 2
fi
