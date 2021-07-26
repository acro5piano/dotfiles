#!/bin/bash

sudo dumpkeys | perl -pe 's/Caps_Lock/Control' | sudo tee /usr/share/keymaps/Caps2Ctrl.map
sudo loadkeys /usr/share/keymaps/Caps2Ctrl.map
