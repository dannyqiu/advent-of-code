#!/usr/bin/env python3
from __future__ import print_function
import sys
import re


def solve(data):
    pipings = {}
    for line in data.split('\n'):
        pipe_regex = re.compile(r"([0-9]+) <-> ([0-9, ]+)")
        match_result = re.match(pipe_regex, line)
        if match_result:
            start = int(match_result.group(1))
            ends = [int(n) for n in match_result.group(2).split(',')]
            pipings[start] = ends

    num_groups = 0
    frontier_starters = set(pipings)
    while frontier_starters:
        connected = set()
        frontier = [frontier_starters.pop()]
        while frontier:
            cur = frontier.pop(0)
            frontier += list(set(pipings[cur]) - connected)
            connected.update(pipings[cur])
        # once we have aggregated all members of this group, we don't need to explore here again
        num_groups += 1
        frontier_starters -= connected

    print("Number of program groups:", num_groups)


if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
