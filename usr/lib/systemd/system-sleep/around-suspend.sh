#!/bin/bash

set -eu

if [ $1 == "pre" ]; then
    light -O
fi

if [ $1 == "post" ]; then
    light -I
    iwctl scan
fi
