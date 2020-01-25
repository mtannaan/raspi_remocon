#!/bin/sh

# sends IR signal with specified name.
# usage: pi-send.sh signal_name

name=$1
python3 bin/irrp.py -p -g17 -f data/pigpio.json "$name"

