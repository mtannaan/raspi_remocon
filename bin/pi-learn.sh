#!/bin/sh
name=$1
python3 bin/irrp.py -r -g9 -f data/pigpio.json --no-confirm --post 130 "$name"
