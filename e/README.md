# e

Programs to estimate **e**, the base of the natural logarithm.

### Using infinite series
Sum the series 1/(n!) for n = 0,1,2... :

    perl6 series.p6

### Without using infinite series
Search for a value e such that the integral from 1 to e of the function 1/x is equal to 1:
  
    octave euler.m
