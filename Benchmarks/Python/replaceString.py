#!/usr/bin/env python3
import fileinput
import os
import sys

fileslist = []

for root, dirs, files in os.walk("."):
    for filename in files:
        if '.plot' in filename:
            if sys.argv[1] in filename:
                fileslist.append(filename)

for filename in fileslist:
    # Read in the file
    with open(filename, 'r') as file :
        filedata = file.read()
    # Replace the target string
    filedata = filedata.replace(sys.argv[2], sys.argv[3])
    # Write the file out again
    with open(filename, 'w') as file:
        file.write(filedata)
            
