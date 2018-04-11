#!/usr/bin/env python3
"""
Read pairs of numbers for the standard input and make a bitmap image

Usage: ./coprime | ./plot.py

       ./coprime | ./plot.py scale
        where scale is an integer scaling factor for the image size.
"""
import numpy
from PIL import Image
import sys

def main():
    scale = 1
    if len(sys.argv) > 1:
        try:
            scale = int(sys.argv[1]) 
        except ValueError:
            sys.stderr.write("Error: scale argument must be an integer.\n")
    # Read pairs into a list:
    points = []
    maximum = 0
    for line in sys.stdin:
        words = line.split()
        x = int(words[0])
        y = int(words[1])
        if x > maximum:
            maximum = x
        if y > maximum:
            maximum = y
        points.append((x,y))

    # List to numpy array:
    arr = numpy.ones([maximum, maximum], dtype = 'uint8') * 255
    arr[0][0] = 0
    for p in points:
        x = p[0] - 1
        y = p[1] - 1
        arr[x][y] = 0
        arr[y][x] = 0

    # Array to image, show it and save to file
    im = Image.fromarray(arr, mode='L').convert('1')
    if scale != 1:
        im = im.resize((maximum * scale, maximum * scale))
    im.show()
    im.save('coprime.png')

if __name__=="__main__":
    main()
