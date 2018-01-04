#!/usr/bin/env python3
from __future__ import print_function
import sys

def solve(data):
    jumps = list(map(int, data.split('\n')))
    steps = 0
    i = 0
    while i < len(jumps):
        j = jumps[i]
        jumps[i] += 1
        i += j
        steps += 1
    print("Steps to reach exit:", steps)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
