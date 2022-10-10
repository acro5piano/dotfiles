#!/usr/bin/env python3

import subprocess

import pyudev


def main():
    context = pyudev.Context()
    monitor = pyudev.Monitor.from_netlink(context)
    monitor.filter_by(subsystem="usb")
    monitor.start()

    for device in iter(monitor.poll, None):

        dt = device.get("DEVTYPE")

        if dt == "usb_device":
            subprocess.call(["xset", "r", "rate", "220", "60"])
            print("Keyboard rate set to 220, 60")


if __name__ == "__main__":
    main()
