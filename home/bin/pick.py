#!/usr/bin/env python

import re
import sys

# Ensure command line argument was provided
if len(sys.argv) < 2:
    print("Please provide a regex as a command line argument.")
    sys.exit(1)

# Get the regex from command line arguments
try:
    regex = re.compile(sys.argv[1])
except re.error as e:
    print("Invalid regex: " + str(e))
    sys.exit(1)

data = sys.stdin.read()

# Find matches and groups
matches = regex.finditer(data)

for match in matches:
    for group in match.groups():
        print(group)
