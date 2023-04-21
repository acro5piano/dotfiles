#!/bin/bash

set -eux

if [ $1 == "pre" ]; then
    # https://bbs.archlinux.org/viewtopic.php?id=217775
    modprobe -r xhci_pci
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    # https://bbs.archlinux.org/viewtopic.php?id=217775
    modprobe xhci_pci
    systemctl restart iwd
    # systemctl restart bluetooth
    # bluetoothctl power on
    # bluetoothctl pairable on
    # bluetoothctl scan on
fi
