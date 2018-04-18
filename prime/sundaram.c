/*
 * Sieve of Sundaram
 */

#include<stdbool.h>
#include<stdio.h>
#include<stdlib.h>

int
main(int argc, char **argv){
        bool *sieve;
        size_t i, j, index;
        size_t max = 1000000;  // find primes up to max
        size_t length;        // length of sieve

        if(argc == 2){
                max = atol(argv[1]);
        }
        length = 1 + (max - 1) / 2; // this sieve finds primes up to 2 * length + 1

        //Initialise sieve:
        sieve = malloc(length * sizeof(*sieve));
        if(sieve == NULL){
                fprintf(stderr, "Memory allocation error.\n");
                return EXIT_FAILURE;
        }
        sieve[0] = false;
        for(i = 1; i < length; i++){ 
                sieve[i] = true;
        }

        // Mark all numbers of the form i+j+2ij as composite:
        for(j = 1; 3 * j < length; ++j){
                for(i = 1; i < j; ++i){
                        index = i + j + 2*i*j;
                        if (index > length) break;
                        sieve[index] = false;
                }
        }

        // Output 2 * n + 1 for all n remaining in sieve: 
        printf("2\n"); // Only finds odd primes: add 2 to list manually
        for(i = 1; i < length; i++){
                if(sieve[i] == true)
                        printf("%ld\n", 2*i + 1);
        }
        return EXIT_SUCCESS;
}
