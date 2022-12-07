#!/bin/bash

set -eux

if [ $1 == "pre" ]; then
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    systemctl restart iwd
    sleep 2
    ifconfig wlan0 down
    iwctl device wlan0 set-property Powered off
fi
