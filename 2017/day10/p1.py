#!/usr/bin/env python3
from __future__ import print_function
import sys

CIRCLE_SIZE = 256

def circular_reverse(arr, start, length):
    def swap(arr, i, j):
        i = i % len(arr)
        j = j % len(arr)
        arr[i], arr[j] = arr[j], arr[i]

    for i in range((length + 1) // 2):
        swap(arr, start + i, start + length - i - 1)


def solve(data):
    lengths = [int(n) for n in data.split(',')]
    circle = list(range(CIRCLE_SIZE))

    curr_idx = 0
    skip_size = 0
    for l in lengths:
        assert l <= CIRCLE_SIZE
        circular_reverse(circle, curr_idx, l)
        curr_idx = (curr_idx + l + skip_size) % CIRCLE_SIZE
        skip_size += 1

    print("Multiple of first two numbers:", circle[0] * circle[1])


if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
