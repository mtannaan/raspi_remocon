#!/bin/sh

# for transmission
echo 'm 17 w  w 17 0' > /dev/pigpio

# for reception
echo 'm 18 r  pud 18 u' > /dev/pigpio
