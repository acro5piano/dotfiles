#!/bin/bash

set -eu

if [ $1 == "pre" ]; then
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    iwctl station wlan0 scan
    iwctl station wlan1 scan || true
fi
