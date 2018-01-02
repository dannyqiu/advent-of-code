#!/usr/bin/env python3
from __future__ import print_function
import sys

def solve(data):
    lines = data.split('\n')
    total = 0
    for l in lines:
        values = list(map(int, l.split()))
        checksum = max(values) - min(values)
        total += checksum
    print("Checksum:", total)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
