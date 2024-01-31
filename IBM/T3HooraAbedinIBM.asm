.data
x:
myArr:  .zero   1000
.text
.globl asm_main
asm_main:
      larl 6, x
      stg     %r14, -4(%r15)
      lay     %r15, -8(%r15)

  # ---------------------------  
  # Write Your Code here
      # registers that can be used: r6, r7, r8, r9, r10, r12, r13, r1    
      # input will be stored in r13, r12 is the loop counter
      BRASL 14, read_int
      LR 13, 2
      LA 12, 2
      input_loop:
            LA 1, 2
            AR 12, 1
            CR 13, 12
            JLE End
            J generate_sums
      
      generate_sums:
            LA 9, 1
            loop1:
                  LA 1, 1
                  AR 9, 1
                  CR 9, 12
                  JE input_loop
                  LA 10, 1
                  loop2:
                        LA 1, 1
                        AR 10, 1
                        LR 2, 9
                        AR 2, 10
                        CR 2, 12
                        JE sum_found  
                        CR 10, 12
                        JE loop1
                        J loop2
            J loop1
      
      sum_found:
            # check wheather r9 is prime or not
            LR 7, 9
            LA 8, 1
            check_9_prime:
                  LA 1, 1
                  AR 8, 1
                  CR 8, 7
                  JE cont
                  LR 2, 8
                  LR 5, 7
                  XR 4, 4
                  DR 4, 8
                  LA 1, 0
                  CR 4, 1
                  JE loop2
                  J check_9_prime
            cont:
            # check wheather r9 is prime or not
            LR 7, 10
            LA 8, 1
            check_10_prime:
                  LA 1, 1
                  AR 8, 1
                  CR 8, 7
                  JE print_res
                  LR 2, 8
                  LR 5, 7
                  XR 4, 4
                  DR 4, 8
                  LA 1, 0
                  CR 4, 1
                  JE loop2
                  J check_10_prime

            print_res:
                  LR 2, 12
                  BRASL 14, print_int
                  LA 2, ' '
                  BRASL 14, print_char
                  LR 2, 9
                  BRASL 14, print_int
                  LA 2, ' '
                  BRASL 14, print_char
                  LR 2, 10
                  BRASL 14, print_int
                  BRASL 14, print_nl
                  J input_loop
      End:
            
  # ---------------------------  

      lay     %r15, 8(%r15)
      lg      %r14, -4(%r15)
      br      %r14


