segment .data
        f_input_format db "%lf", 0
        f_output_format db "%lf", 10, 0
        impossible_format db "Impossible!", 0
        print_int_format: db " %ld ", 0
        read_int_format: db "%ld", 0
        arr: db 1000000 dup(0) 
        asnwers: db 1000000 dup(0) 

segment .bss
        counter resq 1
        n resq 1
        input resq 1
        result1 resq 1
        result2 resq 1
        result3 resq 1
        result4 resq 1
        sum resq 1

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
                je convert_arr_to_balamosalasi

                mov rdi, f_input_format
                mov rsi, input
                call scanf
                movsd xmm0, qword[input]
                movsd qword [arr + 8 * r13], xmm0

                inc r13
                dec r12
                jmp in_loop_1

        convert_arr_to_balamosalasi:
        mov r13, 0; this if the j of the loop
        mov r14, 0; this is the i of the loop
        mov r15, [n]
        outer_loop:
                cmp r13, r15
                je check_for_no_answer

                        inc r13
                mov r14, 0
                inner_loop:
                        cmp r14, r15
                        je outer_loop
                        inc r14
                        cmp r14, r13
                        jle inner_loop

                        ;put arr[i][j] in result1
                        mov r12, r14
                        mov rbx, r13
                        call calculate_index
                        mov rdi, rbp
                        mov rax, 1; added to fix bug
                        movsd xmm1, qword[arr + 8 * rbp]
                        movsd qword[result1], xmm1

                        ;put arr[j][j] in result2
                        mov r12, r13
                        mov rbx, r13
                        call calculate_index
                        mov rdi, rbp
                        mov rax, 1; added to fix bug
                        movsd xmm1, qword[arr + 8 * rbp]
                        movsd qword[result2], xmm1

                        movsd xmm0, qword [result1]
                        movsd xmm1, qword [result2]
                        vdivsd xmm2, xmm0, xmm1
                        movsd qword [result1], xmm2; c is now in result1

                        mov rbx, 0
                        k_loop:
                                cmp rbx, r15
                                jg inner_loop
                                inc rbx
                                
                                ;put arr[i][k] in result2
                                mov r12, r14
                                call calculate_index
                                mov rdi, rbp
                                mov rax, 1; added to fix bug
                                movsd xmm1, qword[arr + 8 * rbp]
                                movsd qword[result2], xmm1

                                ;put arr[j][k] in result3
                                mov r12, r13
                                call calculate_index
                                mov rdi, rbp
                                mov rax, 1; added to fix bug
                                movsd xmm1, qword[arr + 8 * rbp]
                                movsd qword[result3], xmm1

                                ;calc c * A[j][k]
                                movsd xmm0, qword [result1]
                                movsd xmm1, qword [result3]
                                vmulsd xmm2, xmm0, xmm1
                                movsd qword [result4], xmm2
                                
                                ;calc A[i][k] - result4
                                movsd xmm0, qword [result2]
                                movsd xmm1, qword [result4]
                                vsubsd xmm2, xmm0, xmm1
                                movsd qword [result4], xmm2

                                ;put result4 in arr[i][k]
                                mov r12, r14
                                call calculate_index
                                mov rdi, rbp
                                mov rax, 1; added to fix bug
                                movsd xmm0, qword[result4]
                                movsd qword[arr + 8 * rbp], xmm0

                                jmp k_loop

                        jmp inner_loop
                jmp outer_loop

        check_for_no_answer:
                ;r13 is the counter
                ;result1 is the determinan
                mov r13, 1
                mov r15, [n]
                nloop:
                        cmp r13, r15
                        jg calculate_answer
                        mov r12, r13
                        mov rbx, r13
                        call calculate_index
                        mov rdi, rbp
                        mov rax, 1; added to fix bug
                        cmp qword[arr + 8 * rbp], 0
                        je no_answer

                        inc r13
                        jmp nloop

        calculate_answer:
                mov r12, [n]
                ;calculate answer[n]
                ;calculate arr[n][n] and put in result1
                call calculate_index
                mov rdi, rbp
                mov rax, 1; added to fix bug
                movsd xmm1, qword[arr + 8 * rbp]
                movsd qword[result1], xmm1

                ;calculate arr[n][n+1] and put in result1
                mov rbx, [n]
                inc rbx
                call calculate_index
                mov rdi, rbp
                mov rax, 1; added to fix bug
                movsd xmm1, qword[arr + 8 * rbp]
                movsd qword[result2], xmm1

                movsd xmm0, qword [result1]
                movsd xmm1, qword [result2]
                vdivsd xmm2, xmm1, xmm0

                movsd qword[asnwers + 8 * r12], xmm2; answer[n] calculated!
                mov r13, [n] ;r13 is the counter of the outer loop
                ;r14 is the counter of the inner loop
                outer_loop_2:
                        cmp r13, 1
                        jle end
                        dec r13
                        mov r14, r13
                        xorps xmm0, xmm0
                        movsd qword[sum], xmm0
                        inner_loop_2:
                                cmp r14, [n]
                                je outer_loop_2
                                inc r14

                                ;put arr[i][j] in result1
                                mov r12, r13
                                mov rbx, r14
                                call calculate_index
                                mov rdi, rbp
                                mov rax, 1; added to fix bug
                                movsd xmm1, qword[arr + 8 * rbp]

                                movsd xmm0, qword[asnwers + 8 * r14]

                                vmulsd xmm2, xmm1, xmm0 
                                movsd qword[result2], xmm2 ; answers[j] * arr[i][j] is in result2
                                
                                movsd xmm0, qword[sum]
                                movsd xmm1, qword[result2]
                                vaddss xmm2, xmm1, xmm0
                                movsd qword[sum], xmm2

                        jmp outer_loop_2

        no_answer:
                mov rdi, impossible_format
                call printf
                mov rdi, 10
                call putchar

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