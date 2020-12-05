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

    connected = set()
    frontier = [0]
    while frontier:
        cur = frontier.pop(0)
        frontier += list(set(pipings[cur]) - connected)
        connected |= set(pipings[cur])

    print("Programs connected to PID 0:", len(connected))


if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
