#!/usr/bin/env python3
from __future__ import print_function
import sys

def solve(data):
    count = 0
    for line in data.split('\n'):
        words = line.split(' ')
        if len(words) == len(set(words)):
            count += 1
    print("Number of valid passphrases:", count)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
