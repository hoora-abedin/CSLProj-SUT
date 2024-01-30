segment .data
        f_input_format db "%lf", 0
        f_output_format db "%lf", 10, 0
        print_int_format: db " %ld ", 0
        read_int_format: db "%ld", 0
        arr: db 1000 dup(0) 

segment .bss
        n resq 1
        input resq 1
        result1 resq 1
        result2 resq 1

segment .text
        global print_int
        global print_char
        global print_string
        global print_nl
        global read_int
        global read_char
        extern printf
        extern putchar
        extern puts
        extern scanf
        extern getchar
        global asm_main

read_int:
        sub rsp, 8
        mov rsi, rsp
        mov rdi, read_int_format
        mov rax, 1 ; setting rax (al) to number of vector inputs
        call scanf
        mov rax, [rsp]
        add rsp, 8 ; clearing local variables from stack
        ret

print_int:
        sub rsp, 8
        mov rsi, rdi
        mov rdi, print_int_format
        mov rax, 1 ; setting rax (al) to number of vector inputs
        call printf
        add rsp, 8 ; clearing local variables from stack
        ret

calculate_index:
                ;r12 is the first index(i)
                ;rbx is the second index(j)
                mov rbp, [n]
                inc rbp
                mov rax, r12
                dec rax
                imul rbp
                mov rbp, rax
                add rbp, rbx
                dec rbp
                mov rdi, rbp
                ret

asm_main:
        push rbp
        push rbx
        push r12
        push r13
        push r14
        push r15

        sub rsp, 8
        ; -------------------------
        call read_int
        mov [n], rax
        mov rax, [n]
        mov rbp, rax
        inc rbp
        imul rbp
        mov r12, rax; this is the counter of the input loop
        mov r13, 0; this is the index of the array
        in_loop_1:
                cmp r12, 0
                je end_of_input

                mov rdi, f_input_format
                mov rsi, input
                call scanf
                movsd xmm0, qword[input]
                movsd qword [arr + 8 * r13], xmm0

                inc r13
                dec r12
                jmp in_loop_1

        end_of_input:
        mov r13, 0; this if the j of the loop
        mov r14, 0; this is the i of the loop
        mov r15, [n]
        outer_loop:
                cmp r13, r15
                je end
                inc r13
                mov r14, 0
                inner_loop:
                        cmp r14, r15
                        je outer_loop
                        inc r14
                        ;cmp r14, r13
                        ;jle inner_loop

                        ;put arr[i][j] in xmm1
                        mov r12, r14
                        mov rbx, r13
                        call calculate_index
                        mov rdi, rbp
                        mov rax, 1; added to fix bug
                        mov rdi, f_output_format
                        movsd xmm1, qword[arr + 8 * rbp]
                        movsd qword[result1], xmm1
                        movsd xmm0, qword[result1]
                        call printf

                        ;put arr[j][j] in xmm2
                        mov r12, r13
                        mov rbx, r13
                        call calculate_index
                        mov rdi, rbp
                        mov rax, 1; added to fix bug
                        mov rdi, f_output_format
                        movsd xmm2, qword[arr + 8 * rbp]
                        movsd xmm0, xmm2
                        call printf

                        mov rdi, f_output_format
                        movsd xmm0, qword[result1]
                        call printf
                        jmp inner_loop
                jmp outer_loop

        

        end:
        ; -------------------------

        add rsp, 8

        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp

        ret