#!/bin/bash

set -eux

if [ $1 == "pre" ]; then
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    systemctl restart iwd
    # systemctl restart bluetooth
    # bluetoothctl power on
    # bluetoothctl pairable on
    # bluetoothctl scan on
fi
