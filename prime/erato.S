/* erato.S
 *
 * Find prime numbers using the sieve of Eratosthenes.
 *
 * Takes a command line argument N
 * and prints all primes up to N to standard output.
 */

.section .text
.globl _start
_start: 
                /* Parse command line argument as an integer 
                 * argc is at (%rsp)
                 * argv[0] is at 8(%rsp)
                 * argv[1] is at 16(%rsp)
                 */
                cmpq    $2, (%rsp)             # Make sure we have 1 argument
                jne     exit_bad_arguments     #

                movq    16(%rsp), %r14         # pointer to argument 1
                movq    $10,      %rbx         # base 10
                xorq    %rax,     %rax         # parsed number
        parse_loop:
                movb    (%r14), %cl            # Get next byte 
                cmpb    $0, %cl                # zero byte ends parsing
                je      parsed                 # |
                
                cmpb    $48, %cl               # Ensure byte is an ascii digit
                jl      exit_bad_arguments     # |
                cmpb    $57, %cl               # |
                jg      exit_bad_arguments     # |

                subb    $48, %cl               # Convert ascii to integer
                mulq    %rbx                   # rax *= 10
                addb    %cl, %al               # add new digit to rax
                
                incq    %r14                   # move to next byte
                jmp     parse_loop             # |
        parsed:
                movq    %rax, (upper_bound)    # store our parsed value


                /*  Move program break to get memory:
                 *  - Call brk with argument zero to get current break
                 *  - Call brk again with argument (current break + N)
                 *    where we want N extra bytes of memory
                 */
                movq    $12,   %rax           # syscall number for sys_brk
                xorq    %rdi,  %rdi           # argument 0
                syscall
                movq    %rax,  %r8            # store result in %r8

                movq    %r8,   %rdi           # existing break
                addq    (upper_bound),  %rdi  # + new bytes = new break
                movq    $12,   %rax           # sys_brk
                syscall
                cmpq    %r8, %rax             # check return value:
                je      exit_no_memory        # failure if break didn't move

                movq    %rdi,  %r9            # new break
                # Our new memory ranges from address %r8 to %r9
                

                /* Sieve of Erathostanes 
                 *
                 * A natural number is prime iff it is not a multiple of 
                 * any prime number smaller than itself.
                 *
                 * - Initialise an array of length N to zeros
                 * - Loop over elements from 2 -> N/2
                 *     - If array[x] != 0, x is composite, continue loop.
                 *     - If we find array[x] == 0, then x is prime
                 *        -> Mark all multiples of x as composite:
                 *           - Let y = 2x, 3x, 4x ... such that y < N
                 *           - Let array[y] = 1
                 *
                 * Result: array[x] == 0 for prime x 
                 *         array[x] == 1 for composite x
                 */ 

                movq    %r9, %rcx           # Initialise array with zero values
                subq    %r8, %rcx           # | rcx = r9 - r8
            zero_array:                     # |
                movb    $0, (%r8, %rcx, 1)  # | base: r8, offset rcx
                decq    %rcx                # | decrement rcx
                jnz     zero_array          # | continue until rcx = 0

                xorq    %rdx, %rdx          # Divide upper bound (N) by 2
                movq    (upper_bound), %rax # |
                movq    $2, %rbx            # |
                divq    %rbx                # |
                movq    %rax, %r14          # store result in r14

                /* Outer loop:
                 * Loop over integers from 2 -> N
                 * Where N is our upper bound/ biggest number to test
                 */
                movq    $2, %r15            # loop counter for outer loop
            outer_loop: 
                movb    (%r8, %r15, 1), %cl # Is current value in sieve 0?
                cmpb    $0, %cl             # | i.e. prime?
                jne     outer_loop_advance  # | No -> continue outer loop 
                                            # | Yes -> prime
    
                movq    %r15, %rdi          # Found a prime: print it
                call    print_uint          # |
                call    print_endl          # |

                /* We only run the inner loop (mark multiples as composite)
                 * from 2 -> N/2.
                 * Beyond that, we just check for primes and print them
                 */
                cmpq %r14, %r15             # Have we passed N/2?
                jge  outer_loop_advance     # If so, skip inner loop 
                
                /* Inner loop:
                 * When we find a prime, mark all multiples as composite
                 * For prime x, loop over all n*x such that n*x < upper bound)
                 */
                movq    %r15, %r13               # Mark multiples of %r15
                inner_loop:
                    movb    $1, (%r8, %r13, 1)   # Mark %r13 as composite
                    addq    %r15, %r13           # %r13 = next multiple of %r15
                    cmpq    (upper_bound), %r13  
                    jle      inner_loop
                        
            outer_loop_advance:
                incq    %r15
                cmpq    (upper_bound), %r15
                jle     outer_loop
                


exit_success: 
                movq    $60,  %rax   # Exit with status 0
                movq    $0,   %rdi   #   |
                syscall              #   |
exit_no_memory:
                movq    $1,  %rax            # syscall: 1 = sys_write 
                movq    $1,  %rdi            # file:    1 = stdout
                movq    $memory_string, %rsi # buffer:  our error_string
                movq    $26, %rdx            # length in bytes
                syscall
                jmp     exit_failure
exit_bad_arguments:
                movq    $1,  %rax            # syscall: 1 = sys_write 
                movq    $1,  %rdi            # file:    1 = stdout
                movq    $args_string, %rsi   # buffer:  our error_string
                movq    $35, %rdx            # length in bytes
                syscall
exit_failure: 
                movq    $60,  %rax   # Exit with status 1
                movq    $1,   %rdi   #   |
                syscall              #   |

.section .bss
upper_bound: .quad # to store argument N

.section .data
args_string:    .string "Error: expects 1 integer argument.\12"
memory_string:  .string "Error: not enough memory.\12"
emily_d:        .string "Love--is anterior to Life\12Posterior--to Death\12Initial of Creation, and\12The Exponent of Breath.\12"
