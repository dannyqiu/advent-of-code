#!/usr/bin/env python3
from __future__ import print_function
import sys

def enter_group(data, index):
    score = 0
    while index < len(data):
        if data[index] == "!":
            # ignores next character
            index += 2
        elif data[index] == "{":
            add_score, next_index = enter_group(data, index + 1)
            score += add_score
            index = next_index
        elif data[index] == "}":
            return score, index + 1
        elif data[index] == "<":
            add_score, next_index = enter_garbage(data, index + 1)
            score += add_score
            index = next_index
        else:
            index += 1
    return score

def enter_garbage(data, index):
    garbage_count = 0
    while True:
        if data[index] == "!":
            # ignores next character
            index += 2
        elif data[index] == ">":
            # exiting garbage
            return garbage_count, index + 1
        else:
            garbage_count += 1
            index += 1

def solve(data):
    score = enter_group(data, 0)
    print("Total count in garbage:", score)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
