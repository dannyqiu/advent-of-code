#!/usr/bin/env python3
from __future__ import print_function
import sys

def get_value(grid, x, y):
    value = 0
    directions = ((1, 0), (0, -1), (-1, 0), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1))
    for d in directions:
        if (x + d[0], y + d[1]) in grid:
            value += grid[(x + d[0], y + d[1])]
    return value

def fill_grid(grid, x, y, target):
    size = 0
    grid[(x, y)] = 1
    directions1 = ((1, 0), (0, -1))
    directions2 = ((-1, 0), (0, 1))
    while True:
        size += 1
        for d in (directions1 if size % 2 == 1 else directions2):
            for i in range(size):
                x += d[0]
                y += d[1]
                grid[(x, y)] = get_value(grid, x, y)
                if grid[(x, y)] > target:
                    return grid[(x, y)]

def solve(data):
    target = int(data)
    grid = {}
    value = fill_grid(grid, 0, 0, target)
    print("First value written larger:", value)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
