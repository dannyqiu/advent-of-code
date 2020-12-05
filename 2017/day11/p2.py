#!/usr/bin/env python3
from __future__ import print_function
import sys

HEX_DELTAS = {
    # deltas in (dx, dy)
    "sw": (-1, 0),
    "nw": (-1, 1),
    "n": (0, 1),
    "ne": (1, 0),
    "se": (1, -1),
    "s": (0, -1),
}

def dist_to(x, y):
    return min(
        # get to a value (-n, n) or (n, -n), then travel along nw/se
        abs(x + y) + min(abs(x), abs(y)),
        # travel along grid sw/n/ne/s
        abs(x) + abs(y)
    )

def solve(data):
    directions = data.split(',')

    furthest_dist = 0
    x = y = 0
    for d in directions:
        dx, dy = HEX_DELTAS[d]
        x += dx
        y += dy
        furthest_dist = max(furthest_dist, dist_to(x, y))

    print("Furthest ever steps to reach child process:", furthest_dist)


if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
