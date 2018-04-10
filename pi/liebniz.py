#!/usr/bin/env python3
"""
Estimate Pi by summing terms from the infinite series:
    pi/4 = 1 - 1/3 + 1/5 - 1/7 + 1/9 - 1/11 ...
"""
from __future__ import print_function
from itertools import islice
import math

def series():
    i = 1
    while True:
        yield 4.0 / i
        i += 2
        yield - 4.0 / i
        i += 2

for N in [1E3, 1E4, 1E5, 1E6, 1E7, 1E8]:
    s = series()
    pi = sum(islice(s, int(N)))
    print("Terms: %6G; Estimate: %.10f; Error: %G" % (N, pi, math.pi - pi))
