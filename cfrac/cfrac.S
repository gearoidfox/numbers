/* Calculate the continued fraction for a rational
 * using the Euclidean algorithm
 *
 * usage:
 *          cfrac p q
 *
 * positional parameters:
 *          p: numerator (integer)
 *          q: denominator (integer)
 *
 * Prints continued fration [a0;a1;a2;...aN] for p/q
 * where p/q = a0 + 1/(a1 + 1/(a2 + 1/(a3 ...))) 
 * and a0 is an integer, a1,a2...aN are positive integers
 */

.section .text
.globl _start
_start: 
                /* Parse two command line argument as integers
                 * argc is at (%rsp)
                 * argv[0] is at 8(%rsp)   -- Program name
                 * argv[1] is at 16(%rsp)  -- 1st command line parameter
                 * argv[2] is at 24(%rsp)  -- 2nd command line parameter
                 */
                cmpq    $3, (%rsp)              # Make sure we have 2 argument
                jne     exit_bad_arguments      # |
                xorq    %r13, %r13              # boolean: signed input?
        read1:                             
                movq    16(%rsp), %rdi          # pointer to argument 1
                call    parse_int               # read an integer  
                jc      exit_bad_arguments      # check for parse error
                movq    %rax, %r14              # store in r14
                xorq    %rdx, %r13              # signed?
                cmpq    $0, %rdx                # |
                jz      read2                   # |
                neg     %r14                    # remove sign     
        read2:
                movq    24(%rsp), %rdi          # pointer to argument 2
                call    parse_int               # read an integer
                jc      exit_bad_arguments      # check for parse error
                movq    %rax, %r15              # store in r15
                xorq    %rdx, %r13              # signed?
                cmpq    $0, %rdx                # |
                jz      print_start             # |
                neg     %r15                    # remove sign     
                
                # numerator in r14, denominator in r15 (both unsigned)
                # r13 = 1 for negative numbers, 0 for positive

        print_start: 
                                                # Print '[': 
                movq    $1,  %rax               # | syscall: 1 = sys_write 
                movq    $1,  %rdi               # | file:    1 = stdout
                movq    $output_start, %rsi     # | buffer  
                movq    $1, %rdx                # | length in bytes
                syscall

                /*  Separate r14/r15 into integral part and fractional part:
                 */
                
                movq    %r14,   %rax            # divide r14 by r15
                xorq    %rdx,   %rdx            # zero rdx
                divq    %r15                    # | unsigned division
             
                // Adjust integral part for negative numbers: 
                cmpq    $0, %r13                # Is r14/r15 negative?
                jz      adjusted                # |
                neg     %rax                    # | negate integral part
                cmpq    $0, %rdx                # if there is a fractional part:
                jz      adjusted                # |
                decq    %rax                    # | decrement integral part
        adjusted:
                movq    %rax,   %rdi            # print integral part
                call    print_int               # |

                cmpq    $0, %rdx                # end if remainder was 0
                jz      euclid_end              # |
                
                movq    %rdx, %r14              # Remainder -> new numerator
                
                // print separator ';':
                movq    $1, %rax                # | syscall: 1 = sys_write 
                movq    $1, %rdi                # | file:    1 = stdout
                movq    $separator1, %rsi       # | buffer
                movq    $1, %rdx                # | length in bytes
                syscall

                /* calculate frational part a1,a2...
                */
                cmpq    $0,     %r13            # If number is negative,
                jz      discard_int             # |
                movq    %r15,   %r12            # |
                subq    %r14,   %r12            # | r14/15 = 1 - r14/r15
                movq    %r12,   %r14            # |
                /*
                 * do one round of division before starting to print 
                 * the fractional part:
                 */
        discard_int:     
                movq    %r14,   %rax            # divide r14 by r15
                xorq    %rdx,   %rdx            # zero rdx
                divq    %r15                    # | unsigned division
                movq    %r15,   %r14            # Old denominator -> new numerator
                movq    %rdx,   %r15            # Remainder -> new denominator

                /* 
                 * Use euclidean algorithm to calculate the continued fraction
                 * for the fractional part of the input.
                 */
        euclid_loop:    
                movq    %r14,   %rax            # divide r14 by r15
                xorq    %rdx,   %rdx            # zero rdx
                divq    %r15                    # | unsigned division

                movq    %rax,   %rdi            # print quotient
                call    print_int               # |

                cmpq    $0,     %rdx            # end if remainder is 0
                jz      euclid_end              # |

                movq    %r15,   %r14            # Old denominator->new numerator
                movq    %rdx,   %r15            # Remainder -> new denominator

                                                # print separator ',':
                movq    $1, %rax                # | syscall: 1 = sys_write 
                movq    $1, %rdi                # | file:    1 = stdout
                movq    $separator2, %rsi       # | buffer
                movq    $1, %rdx                # | length in bytes
                syscall
                jmp     euclid_loop

        euclid_end:                             # print ']\n'
                movq    $1, %rax                # | syscall: 1 = sys_write 
                movq    $1, %rdi                # | file:    1 = stdout
                movq    $output_end, %rsi       # | buffer
                movq    $2, %rdx                # | length in bytes
                syscall

exit_success: 
                movq    $60,    %rax            # Exit with status 0
                movq    $0,     %rdi            #   |
                syscall                         #   |

exit_bad_arguments:
                movq    $1,     %rax            # syscall: 1 = sys_write 
                movq    $1,     %rdi            # file:    1 = stdout
                movq    $args_string,   %rsi    # buffer:  our error_string
                movq    $36,    %rdx            # length in bytes
                syscall

exit_failure: 
                movq    $60,    %rax            # Exit with status 1
                movq    $1,     %rdi            #   |
                syscall                         #   |

.section .data
args_string:    .string "Error: expects 2 integer arguments.\12"
output_start:   .string "["
separator1:     .string ";"
separator2:     .string ","
output_end:     .string "]\n"
