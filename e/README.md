# e

Programs to approximate **e**, the base of the natural logarithm.

### Using infinite series
- Sum the series 1/(n!) for n = 0,1,2... :

    perl6 series.p6

### Using numerical integration
- Find a value for e such that the integral of dx/x from 1 to e is equal to 1.
  
    octave euler.m

### Using numerial differentiation
- Find a value for e such that d/dx e^x = e^x

    make
    ./e
