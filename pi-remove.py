#!/usr/bin/python3

import sys
import os
import json

json_file = 'data/pigpio.json'

keys = sys.argv[1:]

with open(json_file) as f:
    content = json.load(f)

orig_content = content.copy()

for key in keys:
    del content[key]

backup_file = str(json_file) + '.bak'
counter = 0
while os.path.exists(backup_file):
    counter += 1
    backup_file = str(json_file) + ('.bak%i' % counter)

with open(backup_file, 'w') as f:
    json.dump(orig_content, f)
    print('created backup file:', backup_file)

with open(json_file, 'w') as f:
    f.truncate()
    json.dump(content, f)
    print('successfully removed keys:', keys)
