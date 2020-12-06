#!/usr/bin/env python3
from __future__ import print_function
import sys
import re


def solve(data):
    scanners = {}
    for line in data.split('\n'):
        d, r = [int(n) for n in line.split(':')]
        scanners[d] = r

    severity = 0
    for d, r in scanners.items():
        if d % (r * 2 - 2) == 0:
            severity += d * r

    print("Severity of the whole trip:", severity)


if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
