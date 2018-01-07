#!/usr/bin/env python3
from __future__ import print_function
import sys

class AnswerException(Exception):
    def __init__(self, answer):
        self.answer = answer

class Tower:
    def __init__(self, name, weight):
        self.children = []
        self.name = name
        self.weight = weight
        self.children_weight = 0

    def total_weight(self):
        return self.weight + self.children_weight

def parse_towers(data):
    towers = {}
    for line in data.split('\n'):
        tokens = line.split('->')
        base = tokens[0].split(' ')
        base_name = base[0]
        base_weight = int(base[1][1:-1])
        t = Tower(base_name, base_weight)
        if len(tokens) > 1:
            above = map(str.strip, tokens[1].split(','))
            for c in above:
                t.children.append(c)
        towers[base_name] = t
    for t in towers:
        towers[t].children = list(map(lambda c: towers[c], towers[t].children))
    return towers

def get_root(towers):
    roots = set(towers.keys())
    for t in towers:
        for c in towers[t].children:
            roots.remove(c.name)
    return towers[list(roots)[0]]

def assign_weights(root):
    if root.children:
        root.children_weight = sum(map(assign_weights, root.children))
    return root.total_weight()

def check_balance(root):
    if root.children:
        children = sorted(root.children, key=lambda c: c.total_weight())
        list(map(check_balance, children))
        if children[0].total_weight() != children[-1].total_weight():
            if children[0].total_weight() == children[1].total_weight():
                raise AnswerException(children[0].total_weight() - children[-1].children_weight)
            if children[-2].total_weight() == children[-1].total_weight():
                raise AnswerException(children[-1].total_weight() - children[0].children_weight)

def solve(data):
    towers = parse_towers(data)
    root = get_root(towers)
    try:
        assign_weights(root)
        check_balance(root)
    except AnswerException as e:
        print("Adjusted weight to balance:", e.answer)

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
