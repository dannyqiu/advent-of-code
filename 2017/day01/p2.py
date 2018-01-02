#!/usr/bin/env python3
from __future__ import print_function
import sys

def solve(data):
    digits = list(map(int, list(data)))
    total = 0
    for i in range(len(digits)):
        if digits[i] == digits[(i + len(digits)//2) % len(digits)]:
            total += digits[i]
    print("New captcha solution:", total)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
