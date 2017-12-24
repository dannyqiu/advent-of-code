#!/usr/bin/python3
from __future__ import print_function
import sys

def solve(data):
    lines = data.split('\n')
    total = 0
    for l in lines:
        values = map(int, l.split())
        for i in range(len(values)):
            for j in range(i + 1, len(values)):
                if values[i] % values[j] == 0:
                    total += values[i] / values[j]
                elif values[j] % values[i] == 0:
                    total += values[j] / values[i]
    print(total)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
