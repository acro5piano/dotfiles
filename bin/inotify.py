#!/usr/bin/env python3

import os
import sys

import pyinotify

class EventHandler(pyinotify.ProcessEvent):
    def process_IN_MODIFY(self, event):
        print("Modified:", event.pathname)
        os.system("echo 'A Message has come' | cowsay | wall")

def check_args():
    if len(sys.argv) < 2:
        print('Please specify a file')
        exit(1)

def main():
    check_args()

    # The watch manager stores the watches and provides operations on watches
    wm = pyinotify.WatchManager()
    notifier = pyinotify.Notifier(wm, EventHandler())
    wm.add_watch(sys.argv[1], pyinotify.IN_MODIFY, rec=True)

    notifier.loop()

if __name__ == '__main__':
    main()

