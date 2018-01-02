#!/usr/bin/env python3
from __future__ import print_function
import sys

def solve(data):
    count = 0
    for line in data.split('\n'):
        words = line.split(' ')
        words = list(map(lambda w: ''.join(sorted(w)), words))
        if len(words) == len(set(words)):
            count += 1
    print("Under new system policy, number of valid passphrases:", count)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
