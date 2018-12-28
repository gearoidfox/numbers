.text

/*
 *    parse_int:
 *   
 *    parse an integer from ascii string
 *
 *    args: %rdi pointer to string
 *    
 *    returns: %rax integer
 *             %rdx sign (0: positive, 1: negative)
 *
 *    sets the carry flag on error (no digits can be parsed)
 *
 *    Promises not to clobber any registers.
 *
 */
.globl parse_int
.type  parse_int, @function
parse_int:
                pushq   %rbx             # Save register contents on stack
                pushq   %rcx             # |
                pushq   %rdi             # |
                pushq   %r15             # |

                movq    $10,    %rbx     # base 10
                xorq    %rax,   %rax     # parsed number
                movq    $0,     %r15     # store sign in r15 

                /* Check if first byte is an ascii digit
                 * yes -> start parsing digits
                 * no  -> parse a leading sign (+/-)
                 */
                movb    (%rdi), %cl      
                cmpb    $48,    %cl      
                jb      check_sign       
                cmpb    $57,    %cl      
                ja      check_sign       
                jmp     parse_loop

        check_sign:
                cmpb    $43,    (%rdi)   # is byte '+'?
                je      found_sign       # |

                cmpb    $45,    (%rdi)   # is byte '-'?
                jne     parse_error      # | first byte not digit or sign: error
                movq    $1,     %r15     # | change r15 to indicate sign
        found_sign:
                incq    %rdi             # move to next byte

        parse_loop:
                movb    (%rdi), %cl      # Get next byte 
                
                cmpb    $48,    %cl      # Non-digit ends parsing
                jb      set_sign         # |
                cmpb    $57,    %cl      # |
                ja      set_sign         # |

                subb    $48,    %cl      # Convert ascii to integer
                mulq    %rbx             # rax *= 10
                addb    %cl,    %al      # add new digit to rax
                
                incq    %rdi             # move to next byte
                jmp     parse_loop       # |

        set_sign:                        # If rdx == 1,
                cmpq    $0,     %r15     # rax = -rax
                je      parsed           #
                neg     %rax
        parsed:
                movq    %r15, %rdx       # return sign
                popq    %r15             # restore registers from stack
                popq    %rdi             # |
                popq    %rcx             # |
                popq    %rbx             # |
                clc
                ret
        parse_error:                     
                stc
                ret

/*  print line feed '\n' to stdout
 */
.globl print_endl
.type  print_endl, @function
print_endl:
                pushq %rax # Store register contents on stack
                pushq %rbx # |
                pushq %rdi # |
                pushq %rdx # |

                movq  $1,   %rax # syscall number (1 = sys_write)
                movq  $1,   %rdi # file descriptor (stdout)
                movq  $1,   %rdx # buffer length 1
                push  $10        # line feed
                movq  %rsp, %rsi # use stack pointer as buffer
                syscall          
                popq   %rbx      # remove character from stack
    
                popq   %rdx # | Restore registers from stack
                popq   %rdi # |
                popq   %rbx # |
                popq   %rax # |

                ret    # print_endl 

/*
 *    print_uint: print an unsigned integer value to stdout
 *
 *      args: %rdi integer value
 *
 *    - repeatedly divides argument by 10
 *    - converts each remainder digit to ASCII character
 *    - writes characters to the red zone
 *    - calls sys_write to print to stdout
 *
 *    Promises not to clobber any registers.
 */
.global print_uint
.type   print_uint, @function
print_uint:
                pushq   %rax  # Store register contents on the stack
                pushq   %rbx  # |
                pushq   %rcx  # |
                pushq   %rdx  # |
                pushq   %rdi  # |
                pushq   %r11  # |
                pushq   %r13  # |
                pushq   %r14  # |
                pushq   %r15  # |

                
                lea     -64(%rsp), %r14 
                xorq    %r15, %r15     # zero a counter to track digits
                movq    $32,  %r13     #
                movq    $10,  %rbx     # base 10
                movq    %rdi, %rax     # must store dividend in rax
        pui_div_loop:
                xorq    %rdx, %rdx            # | zero before division
                divq    %rbx                  # | divide rax by 10
                addq    $48,  %rdx            # | add 48 to remainder (ascii)
                movb    %dl,  (%r14, %r13, 1) # | write ascii to red zone
                decq    %r13                  # | decrease offset
                incq    %r15                  # | increase digit counter
                cmpq    $0,   %rax            # while quotient (rax) != 0
                jne     pui_div_loop          #   
                
                addq    $33,    %r14     # Calculate location of string
                subq    %r15,   %r14     # |
                movq    %r14,   %rsi     # | rsi: buffer for sys_write
                movq    $1,     %rax     # syscall number (1 = sys_write)
                movq    $1,     %rdi     # file descriptor (stdout)
                movq    %r15,   %rdx     # buffer length
                syscall
                
                popq    %r15   # Restore contents of registers from stack
                popq    %r14   # |
                popq    %r13   # |
                popq    %r11   # |
                popq    %rdi   # |
                popq    %rdx   # |
                popq    %rcx   # |
                popq    %rbx   # |
                popq    %rax   # |

                ret     # print_uint 

/*
 *    print_int: print an signed integer value to stdout
 *
 *      args: %rdi signed integer value
 *
 *    - for positive values, calls print_uint
 *    
 *    - for negative values, writes '-', negates the argument,
 *      and then calls print_uint
 *
 *    Promises not to clobber any registers.
 */
.global print_int
.type   print_int, @function
print_int:
                pushq   %rax  # Store register contents on the stack
                pushq   %rbx  # |
                pushq   %rcx  # |
                pushq   %rdx  # |
                pushq   %rdi  # |
                pushq   %r11  # |

                cmpq    $0, %rdi
                jge     print_value
        print_sign:
                pushq   %rdi 
                pushq   $45 
                movq    %rsp,   %rsi     # | rsi: buffer for sys_write
                movq    $1,     %rax     # syscall number (1 = sys_write)
                movq    $1,     %rdi     # file descriptor (stdout)
                movq    $1,     %rdx     # buffer length
                syscall
                popq    %rax
                popq    %rdi
                neg %rdi
                
        print_value:
                call print_uint
                
                popq    %r11   # |
                popq    %rdi   # |
                popq    %rdx   # |
                popq    %rcx   # |
                popq    %rbx   # |
                popq    %rax   # |

                ret     # print_uint 
