#!/usr/bin/env python3

import subprocess
import time

import pyudev


def main():
    context = pyudev.Context()
    monitor = pyudev.Monitor.from_netlink(context)
    # monitor.filter_by(subsystem="usb")
    monitor.start()

    for device in iter(monitor.poll, None):

        dt = device.get("DEVTYPE")

        if dt == "usb_device" or dt == "link":
            if dt == "link":
                # Bluetooth device requires this delay
                time.sleep(2)
            subprocess.call(["xset", "r", "rate", "220", "60"])
            print("Keyboard rate set to 220, 60")


if __name__ == "__main__":
    main()
