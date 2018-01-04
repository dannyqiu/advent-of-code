#!/usr/bin/env python3
from __future__ import print_function
import sys

def redistribute(banks):
    b = banks.index(max(banks))
    mem = banks[b]
    each = mem // len(banks)
    extras = mem - each * len(banks)
    banks[b] = 0
    for i in range(b + 1, len(banks)):
        banks[i] += each + (1 if i - b <= extras else 0)
    for i in range(0, b + 1):
        banks[i] += each + (1 if (len(banks) - b) + i <= extras else 0)

def solve(data):
    banks = list(map(int, data.split()))
    configs = set()
    cycles = 0
    while tuple(banks) not in configs:
        configs.add(tuple(banks))
        redistribute(banks)
        cycles += 1
    print("Number of redistribution cycles:", cycles)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
