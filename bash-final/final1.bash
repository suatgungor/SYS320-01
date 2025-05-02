#!/bin/bash

echo "challange 1"
 
curl -s http://10.0.17.6/IOC.html > page.html | grep "<td>" page.html > lines.txt |cut -d'>' -f2 lines.txt | cut -d'<' -f1 | awk 'NR%2==1' > IOC.txt

cat IOC.txt
