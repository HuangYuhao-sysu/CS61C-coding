.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    # end
    addi t0, zero, 1
    blt a2, t0, error1
    blt a3, t0, error2
    blt a4, t0, error2
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, zero         # int i = 0
    mv s6, zero         # step * stride for v0
    mv s7, zero         # step * stride for v1
    mv s8, zero         # result
loop_start:
    bge s5, s2, loop_end
    slli t0, s6, 2
    slli t1, s7, 2
    add, t2, s0, t0     # addr + offset for v0
    add, t3, s1, t1
    lw t4, 0(t2)        # load data
    lw t5, 0(t3)
    mul t6, t4, t5
    add s8, s8, t6
    addi s5, s5, 1
    add s6, s6, s3
    add s7, s7, s4
    j loop_start
loop_end:
    mv a0, s8
    j exit
error1:
    addi, a1, zero, 75
    j exit2
error2:
    addi, a1, zero, 76
    j exit2
exit:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    addi sp, sp, 36
    # end
    ret
