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
    n2:      .zero   8

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
                je End
                brasl 14, read_double
                std 0, arr-x(6, 8)
                la 7, 8
                ar 8, 7
                la 7, 1
                sr 12, 7
                j input_loop
                
            End:
            larl 13, n2
            l 12, 0(13)
            la 8, 0
            print_loop:
                la 7, 0
                cr 12, 7
                je End2
                ld 0, arr-x(6, 8)
                brasl 14, print_double
                la 2, ' '
                brasl 14, print_char
                la 7, 8
                ar 8, 7
                la 7, 1
                sr 12, 7
                j print_loop
        End2:
        # ---------------------------  

        lay     %r15, 200(%r15)
        lmg     %r11, %r15, -40(%r15)
        br      %r14
