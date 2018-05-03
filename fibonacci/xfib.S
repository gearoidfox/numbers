/*
 * Print entries in the fibonacci sequence in hexadecimal to the standard
 * output. (x86_64/Linux)
 * Use 128 bits for integers (2 registers).
 */

.text
.global _start

_start: 
                movq $186,%rcx  # Max n to print
                movq $0,  %r12  # lsq f(n-1)
                movq $0,  %r13  # msq f(n-1)
                movq $1,  %r14  # lsq f(n)
                movq $0,  %r15  # msq f(n)
main_loop:
                push %rcx              #  |
                push %r12              #  |
                call print_big_integer # print f(n)
                pop %r12               #  |
                pop %rcx               #  |

                xaddq %r13,  %r15   # update upper quadwords
                jc    exit_failure  # we've overflowed 128 bit integers

                xaddq %r12,  %r14   # update lower quadwords
                jnc   no_carry      # check for carry on this addition
                addq  $1,    %r15   # Add carried bit to the upper quadword
                jc exit_failure    # and check for overflows there.
        no_carry:
                decq %rcx          # Decrement counter 
                cmpq $0,    %rcx   # Test loop end condition
                jnl  main_loop     #   |
exit_success: 
                movq  $60,  %rax   # Exit with status 0
                movq  $0,   %rdi   #   |
                syscall            #   |
exit_failure: 
                movq  $60,  %rax   # Exit with status 0
                movq  $1,   %rdi   #   |
                syscall            #   |

/*
 *    print_big_integer: print 128 bit integer in hexadecimal notation
 *        arguments:
 *        lower 64 bits stored in %r14
 *        upper 64 bits stored in %r15
 *
 *    - iteratively divide input number by 16
 *    - convert remainders to ascii codes and push onto stack
 *    - print digits off the stack
 *    - end by printing '\n'
 */
print_big_integer:
                xorq  %r12, %r12   # zero counter to track digits
                movq  $16,  %rbx   # hex output
                
                movq  %r14, %rax
        div_loop_lsq:              # calculate digits for lower quad
                xorq  %rdx, %rdx   #
                divq  %rbx         # divide rax by 16
                cmpq  $9,  %rdx    # check if remainder is 0-9 or A-F
                jg    letter_digit
                addq  $48,  %rdx   # add 48 to get 0-9 ASCII code
                jmp   cont
        letter_digit:
                addq  $55,  %rdx   # add 55 to get A-F ASCII code
        cont:
                push  %rdx         # push digit onto stack
                incq  %r12         # track digits on stack
                cmpq  $0,   %rax   # continue while quotient (rax) != 0
                jne   div_loop_lsq #   |

                cmpq  $0,   %r15   # If upper 64 bits is zero, skip to
                je    print_loop   #  printing
                movq  %r15, %rax
        # if upper quad > 0, pad lower quad to sixteen digits
        pad_loop:
                cmpq  $16,  %r12
                je    div_loop_msq
                incq  %r12
                push  $48
                jmp   pad_loop

        div_loop_msq:              # calculate digits for upper quad
                xorq  %rdx, %rdx   # zero before division
                divq  %rbx         # divide rax by 10
                cmpq  $9,   %rdx   # check if remainder is 0-9 or A-F
                jg    letter_digit2
                addq  $48,  %rdx   # add 48 to get 0-9 ASCII digit code
                jmp   cont2
        letter_digit2:
                addq  $55,  %rdx   # add 55 to get A-F ASCII digit code
        cont2:
                push  %rdx         # push digit onto stack
                incq  %r12         # track digits on stack
                cmpq  $0,   %rax   # continue while quotient (rax) != 0
                jne   div_loop_msq #   |

        print_loop:
                movq  $1,   %rax   # syscall number (1 = sys_write)
                movq  $1,   %rdi   # file descriptor
                movq  %rsp, %rsi   # use stack pointer as buffer
                movq  $1,   %rdx   # buffer length 1
                syscall
                decq  %r12         # decrement digit count
                pop   %rbx         # pop a value off the stack
                cmpq  $0,   %r12
                jne   print_loop
        endl: 
                push  $10        # line feed
                syscall          #   |
                pop   %rbx
                ret 

