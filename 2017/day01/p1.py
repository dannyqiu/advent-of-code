#!/usr/bin/python3
from __future__ import print_function
import sys

def solve(data):
    digits = map(int, list(data))
    total = 0
    for i in range(len(digits)):
        if digits[i] == digits[(i + 1) % len(digits)]:
            total += digits[i]
    print(total)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
