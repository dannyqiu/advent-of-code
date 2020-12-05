#!/usr/bin/env python3
from __future__ import print_function
from functools import reduce
from operator import xor
import sys

CIRCLE_SIZE = 256

ADDITIONAL_LENGTHS = [17, 31, 73, 47, 23]
ROUNDS = 64

def circular_reverse(arr, start, length):
    def swap(arr, i, j):
        i = i % len(arr)
        j = j % len(arr)
        arr[i], arr[j] = arr[j], arr[i]

    for i in range((length + 1) // 2):
        swap(arr, start + i, start + length - i - 1)


def sparse_to_dense(arr):
    assert len(arr) % 16 == 0
    dense_hash = []
    for i in range(len(arr) // 16):
        dense_hash.append(reduce(xor, arr[i*16:(i+1)*16]))
    return dense_hash


def solve(data):
    lengths = [ord(n) for n in data] + ADDITIONAL_LENGTHS
    circle = list(range(CIRCLE_SIZE))

    curr_idx = 0
    skip_size = 0
    for _ in range(ROUNDS):
        for l in lengths:
            assert l <= CIRCLE_SIZE
            circular_reverse(circle, curr_idx, l)
            curr_idx = (curr_idx + l + skip_size) % CIRCLE_SIZE
            skip_size += 1

    hash = bytearray(sparse_to_dense(circle)).hex()
    print("Hash of input:", hash)


if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
