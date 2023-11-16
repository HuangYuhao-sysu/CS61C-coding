.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#    a0 (int*) is the pointer to the array
#    a1 (int)  is the # of elements in the array
# Returns:
#    None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# int relu(int* a0, int a1) {
#     if (a1 < 1) {
#         return 78;
#     }
#     for(int i = 0; i < a1, ++i) {
#         a0[i] = a0[i] < 0 ? 0 : a[i];
#     }
#     return 0;
# }
# ==============================================================================

relu:
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    # end
    addi t0, zero, 1
    blt a1, t0, error
    mv s0, a0       # store vector pointer
    mv s1, a1       # store size
    mv s2, zero     # store loop number
loop_start:
    bge s2, s1, loop_end
    slli t0, s2, 2  # *4 for index (int size)
    add t1, t0, s0  # addr + offset
    lw t2, 0(t1)    # load a[i]
    slti t3, t2, 0
if1:
    beq t3, zero, endif1
    mv t2, zero
endif1:
    sw t2, 0(t1)
    addi s2, s2, 1
    j loop_start
loop_end:
    mv a0 ,zero
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    j exit
    # end
error:
    addi a1, zero, 78
    j exit2
