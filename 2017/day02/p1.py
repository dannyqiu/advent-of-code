#!/usr/bin/python3
from __future__ import print_function
import sys

def solve(data):
    lines = data.split('\n')
    total = 0
    for l in lines:
        values = map(int, l.split())
        checksum = max(values) - min(values)
        total += checksum
    print(total)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
