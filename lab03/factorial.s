.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    # int factorial(k) {
    #    if (k == 0) {
    #        return 1;
    #    } else if (k == 1) {
    #        return 1;
    #    } else {
    #        return mul(k, factorial(k - 1));
    #    }
    # }
    # BEGIN PROLOGUE
    addi sp, sp -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    # END PROLOGUE
    addi t0, x0, 0
    addi t1, x0, 1
    addi t2, x0, 0
    mv s0, a0
    beq s0, t0, return_0
    beq s0, t1, return_1
    addi s1, s0, -1
    mv a0, s1
    jal ra, factorial
    mv s2, a0
    mv a0, s0
    mv a1, s2
    jal ra, mul
    mv t2, a0
    j exit
return_0:
    mv t2, t1
    j exit
return_1:
    mv t2, t1
    j exit
exit:
    # BEGIN EPILOGUE
    mv a0, t2
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    # END EPILOGUE
    jr ra
   
mul:
    #BEGIN PROLOGUE
    addi sp, sp -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    #END PROLOGUE
    mv t0, a0 # loop num
    mv t1, a1 # 
    mv t2, x0 # prod
loop:
    beq t0, x0, mul_exit
    add t2, t2, t1
    addi t0, t0, -1
    j loop
mul_exit:
    # BEGIN EPILOGUE
    mv a0, t2
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    # END EPILOGUE
    jr ra