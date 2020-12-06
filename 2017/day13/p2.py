#!/usr/bin/env python3
from __future__ import print_function
import itertools
import sys
import re


def solve(data):
    scanners = {}
    for line in data.split('\n'):
        d, r = [int(n) for n in line.split(':')]
        scanners[d] = r

    for delay in itertools.count():
        caught = False
        for d, r in scanners.items():
            if (d + delay) % (r * 2 - 2) == 0:
                caught = True
                break
        if not caught:
            print("Wasn't caught with delay:", delay)
            break


if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
