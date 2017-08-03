##################
#Python Script to convert shit to CSV from JSON
#Usage: python json5csv.py  fx23.json > out.csv
#Dont be an idiot 
##################

import fileinput
import json
import csv
import sys

l = []
for line in fileinput.input():
    l.append(line)
myjson = json.loads(''.join(l))
keys = {}
for i in myjson:
    for k in i.keys():
        keys[k] = 1
mycsv = csv.DictWriter(sys.stdout, fieldnames=keys.keys(),
                       quoting=csv.QUOTE_MINIMAL)
mycsv.writeheader()
for row in myjson:
    mycsv.writerow(row)

