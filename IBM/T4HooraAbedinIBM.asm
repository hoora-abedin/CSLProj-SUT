.text
.globl lcm
    lcm:
  stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)

  # ---------------------------  
  # Write Your Code here 
      BRASL 14, gcd
      LR 10, 2
      LR 7, 8
      MR 6, 13
      XR 6, 6
      DR 6, 10
      LR 2, 7
  # ---------------------------  

        lay     %r15, 8(%r15)
  lg      %r14, -4(%r15)
        br      %r14


.text
.globl gcd
    gcd:
  stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)

  # ---------------------------  
  # Write Your Code here        
      LR 13, 2
      LR 8, 3
      LR 7, 8
      SR 7, 13
      LA 9, 0
      CR 7, 9
      JL change_order
      continue1:# 13 is the first parameter, 8 is the second parameter, 10 is the result, 9 is the loop counter, others are free
      LA 10, 1
      LR 9, 10
      SR 9, 10
      loop:
            CR 9, 13
            JE loop_end 
            LA 7, 1
            AR 9, 7
            LR 7, 13
            # we want to divide r13 / r9 and get mod
            XR 6, 6
            DR 6, 9
            LA 7, 0
            CR 7, 6
            JNE loop
            
            LR 7, 8
            # we want to divide r8 / r9 and get mod
            XR 6, 6
            DR 6, 9
            LA 7, 0
            CR 7, 6
            JNE loop
            LR 10, 9
            J loop

      change_order:
            LR 9, 13
            LR 13, 8
            LR 8, 9
            J continue1

      loop_end:
            LR 2, 10
  # ---------------------------  

        lay     %r15, 8(%r15)
  lg      %r14, -4(%r15)
        br      %r14
