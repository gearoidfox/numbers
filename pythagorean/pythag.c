/*
 * pythag.c
 *
 * Generate primitive pythagorean triples.
 *
 * Input: Pairs of coprime integers, one pair per line, whitespace separated,
 * e.g.
 * 2 1
 * 3 2
 * 4 3
 *
 * Output: integers a b c, where a*a + b*b = c*c and a < b, e.g.
 * 3 4 5
 * 5 12 13
 * 7 24 25
 *
 * If a filename is supplied as a command line argument,
 * reads input from this file. Otherwise, reads from the
 * standard input.
 *
 * Formula:
 *
 * (a, b, c) = (2pq, p^2 - q^2, p^2 + q^2)
 *
 * where:
 *  1. p and q are coprime (not verified here)
 *  2. p > q
 *  3. p and q have opposite parity, i.e. one is odd, the other is even.
 */

#include<stdio.h>

int main(int argc, char** argv)
{
        unsigned long p, q, a, b, c;
        FILE* infile;

        if(argc == 1) {
                infile = stdin;
        } else {
                infile = fopen(argv[1], "r");
                if( NULL == infile) {
                        fprintf(stderr, "Error, couldn't read from file [%s]\n",
                                        argv[1]);
                }
        }
        
        while(fscanf(infile, "%lu %lu\n", &p, &q) == 2){
                if( (1 & p) == (1 & q) ) continue;  // ensure opposite parity

                a = 2 * p * q;

                p *= p;
                q *= q;
                if(p > q){
                        b = p - q;
                } else {
                        b = q - p;
                }
                c = p + q;

                if(a < b){
                        printf("%lu %lu %lu\n", a, b ,c);
                } else {
                        printf("%lu %lu %lu\n", b, a ,c);
                }
        }
        
        return 0;
}
