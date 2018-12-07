.text

/*  print line feed '\n' to stdout
 */
.globl print_endl
.type   print_endl, @function
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
