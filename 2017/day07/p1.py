#!/usr/bin/env python3
from __future__ import print_function
import sys

def solve(data):
    children = set()
    towers = set()
    for line in data.split('\n'):
        tokens = line.split('->')
        base = tokens[0].split(' ')[0]
        towers.add(base)
        if len(tokens) > 1:
            above = map(str.strip, tokens[1].split(','))
            for c in above:
                children.add(c)
                towers.add(c)
    very_bottom = list(towers.difference(children))[0]
    print("Name of the bottom program:", very_bottom)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
