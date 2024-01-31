.data
    read_double_format:   .asciz "%lf"
    read_double_format6:   .asciz "%lf"
    read_double_format5:   .asciz "%lf"
    read_double_format4:   .asciz "%lf"
    print_double_format:   .asciz "%lf"
    read_double_format3:   .asciz "%lf"
    read_double_format2:   .asciz "%lf"
    read_double_format1:   .asciz "%lf"

    read_int_format:   .asciz "%d"
    read_int_format6:   .asciz "%d"
    read_int_format5:   .asciz "%d"
    read_int_format4:   .asciz "%d"
    print_int_format:  .asciz "%d"
    read_int_format3:   .asciz "%d"
    read_int_format2:   .asciz "%d"
    read_int_format1:   .asciz "%d"

    x:
    arr:    .zero   8000000
    n:      .zero   8
    n2:     .zero   8
    result1: .zero   8 

.text

.globl asm_main

    read_double: # moves double to f0
        stg     %r14,   -8(%r15)
        lay     %r15,   -168(%r15)
        larl    %r2,    read_double_format
        brasl   %r14,   scanf
        lay     %r15,   168(%r15)
        lg      %r14,   -8(%r15)
        br      %r14

    print_double:   # print double in f0
        stg     %r14,   -8(%r15)
        lay     %r15,   -168(%r15)
        larl    %r2,    print_double_format
        brasl   %r14,   printf
        lay     %r15,   168(%r15)
        lg      %r14,   -8(%r15)
        br      %r14

    print_int:
	    stg     %r14,   -8(%r15)
        lay     %r15,   -168(%r15)
        lr      %r3,    %r2
        larl    %r2,    print_int_format
        brasl   %r14,   printf
        lay     %r15,   168(%r15)
        lg      %r14,   -8(%r15)
        br      %r14


    print_nl:
        stg     %r14,   -8(%r15)
        lay     %r15,   -168(%r15)
        la      %r2,    10
        brasl   %r14,   putchar
        lay     %r15,   168(%r15)
        lg      %r14,   -8(%r15)
        br      %r14


    read_int:
	    stg     %r14,   -8(%r15)
        lay     %r15,   -168(%r15)
        lay     %r3,    0(%r15)
        larl    %r2,    read_int_format
        brasl   %r14,   scanf
        l       %r2,    0(%r15)
        lay     %r15,   168(%r15)
        lg      %r14,   -8(%r15)
        br      %r14

    print_char:
	    stg     %r14,   -8(%r15)
        lay     %r15,   -168(%r15)
        brasl   %r14,   putchar
	    lay     %r15,   168(%r15)
	    lg      %r14,   -8(%r15)
        br      %r14

    calculate_index:
	    stg     %r14,   -8(%r15)
        lay     %r15,   -168(%r15)
        # ---------------------------  
        # r9 is the first index(i)
        # r5 is the second index(j)
        larl 8, n
        l 4, 0(8)
        la 3, 1
        ar 4, 3
        la 3, 1
        sr 9, 3
        mr 8, 4
        ar 9, 5
        lr 3, 1
        sr 9, 3
        lr 2, 9
        # ---------------------------  
	    lay     %r15,   168(%r15)
	    lg      %r14,   -8(%r15)
        br      %r14


    asm_main:
        larl 6, x
        stmg     %r11, %r15, -40(%r15)
        lay     %r15, -200(%r15)

        # ---------------------------  
        # Write Your Code here   
            # get size from input and store in memory
            brasl 14, read_int
            larl 13, n
            st 2, 0(13)

            # calculate n(n+1) and store in n2
            lr 9, 2
            lr 13, 2
            la 7, 1
            ar 13, 7
            mr 8, 13
            larl 13, n2
            st 9, 0(13)

            # get n(n+1) float array inputs from input and store in memory
            larl 13, n2
            l 12, 0(13)
            la 8, 0
            input_loop:
                la 7, 0
                cr 12, 7
                je convert_arr_to_balamosalasi
                brasl 14, read_double
                std 0, arr-x(6, 8)
                la 7, 8
                ar 8, 7
                la 7, 1
                sr 12, 7
                j input_loop
                
            convert_arr_to_balamosalasi:
            la 7, 0 # this if the counter of the outer loop -> 7 (13)
            la 10, 0 # this if the counter of the inner loop -> 10 (14)
            larl 13, n 
            l 13, 0(13) # this is n -> 13 (15)

            outer_loop:
                cr 7, 13
                je End
                la 3, 1
                ar 7, 3

                la 10, 0
                inner_loop:
                        cr 10, 13
                        je outer_loop
                        la 3, 1
                        ar 10, 3
                        # cr 10, 7
                        # jle inner_loop

                        # get arr[j][j] and put in result 1
                        la 2, 0
                        brasl 14, print_char
                        lr 5, 7
                        lr 9, 7
                        brasl 14, calculate_index
                        lr 9, 2
                        la 4, 8
                        mr 8, 4
                        ld 0, arr-x(6, 9)
                        larl 8, result1
                        std 0, 0(8)

                        # get arr[j][i]
                        la 2, 0
                        brasl 14, print_char
                        lr 5, 7
                        lr 9, 10
                        brasl 14, calculate_index
                        lr 9, 2
                        la 4, 8
                        mr 8, 4
                        ld 0, arr-x(6, 9)
                        
                        # calculate c and store in result1
                        larl 8, result1
                        ddb 0, 0(8)
                        larl 8, result1
                        std 0, 0(8)

                        la 12, 0
                        k_loop: # this if the counter of the k loop -> 12 (rbx)
                                la 3, 1
                                ar 3, 13
                                cr 12, 3
                                je inner_loop
                                la 3, 1
                                ar 12, 3


                                


                                j k_loop
                        j inner_loop
                j outer_loop
            End:
        # ---------------------------  

        lay     %r15, 200(%r15)
        lmg     %r11, %r15, -40(%r15)
        br      %r14
