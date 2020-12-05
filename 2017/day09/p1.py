#!/usr/bin/env python3
from __future__ import print_function
import sys

def enter_group(data, index, group_depth):
    score = group_depth
    while index < len(data):
        if data[index] == "!":
            # ignores next character
            index += 2
        elif data[index] == "{":
            add_score, next_index = enter_group(data, index + 1, group_depth + 1)
            score += add_score
            index = next_index
        elif data[index] == "}":
            return score, index + 1
        elif data[index] == "<":
            index = enter_garbage(data, index + 1)
        else:
            index += 1
    return score

def enter_garbage(data, index):
    while True:
        if data[index] == "!":
            # ignores next character
            index += 2
        elif data[index] == ">":
            # exiting garbage
            return index + 1
        else:
            index += 1

def solve(data):
    score = enter_group(data, 0, 0)
    print("Total score of all groups:", score)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
