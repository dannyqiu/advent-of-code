#!/usr/bin/env python3
from __future__ import print_function
import sys

def closest_square(n):
    i = 1
    while i ** 2 < n:
        i += 2
    return i

def solve(data):
    target = int(data)
    size = closest_square(target)
    count = (target - ((size - 2) ** 2)) % (size - 1)
    to_middle_dist = abs(count - size / 2)
    to_center_dist = size / 2
    print("Number of steps:", to_middle_dist + to_center_dist)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
