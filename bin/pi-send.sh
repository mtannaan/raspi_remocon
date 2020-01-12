#!/bin/sh
name=$1
python3 bin/irrp.py -p -g17 -f data/pigpio.json "$name"

