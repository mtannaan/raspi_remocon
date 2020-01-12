#!/usr/bin/python3
 
import json
 
with open('data/pigpio.json') as f:
	loaded = json.load(f)
	for label in loaded.keys():
		print(label)
