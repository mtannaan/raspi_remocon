#!/bin/sh

# configures GPIO ports.

# for transmission
echo 'm 17 w  w 17 0' > /dev/pigpio

# for reception
echo 'm 9 r  pud 9 u' > /dev/pigpio
