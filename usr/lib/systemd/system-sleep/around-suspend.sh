#!/bin/bash

set -eux

if [ $1 == "pre" ]; then
    # bluetoothctl power off
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    systemctl restart iwd
    # bluetoothctl power on
    # bluetoothctl pairable on
    # bluetoothctl scan on
fi
