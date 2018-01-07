#!/usr/bin/env python3
from __future__ import print_function
import sys

DEFAULT_VALUE = 0

def ensure_reg(registers, reg):
    if reg not in registers:
        registers[reg] = DEFAULT_VALUE
    return registers[reg]

def verify_cond(registers, reg_cond, cond, value_cond):
    reg_value = ensure_reg(registers, reg_cond)
    stmt = '{} {} {}'.format(reg_value, cond, value_cond)
    return eval(stmt)

def run_code(registers, instructions):
    for instr in instructions:
        tokens = instr.split()
        reg = tokens[0]
        is_inc = tokens[1] == "inc"
        amount = int(tokens[2])
        reg_cond = tokens[4]
        cond = tokens[5]
        value_cond = int(tokens[6])
        if verify_cond(registers, reg_cond, cond, value_cond):
            reg_value = ensure_reg(registers, reg)
            registers[reg] = reg_value + amount * (1 if is_inc else -1)

def solve(data):
    registers = {}
    instructions = data.split('\n')
    run_code(registers, instructions)
    print("Largest value in any register:", max(registers.values()))

if __name__ == "__main__":
    data = sys.stdin.read()
    data = data.strip()
    solve(data)
