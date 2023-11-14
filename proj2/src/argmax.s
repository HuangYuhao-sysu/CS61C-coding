.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# int argmax(int* a0, int a1) {
#     if (a1 < 1) {
#         return 77;
#     }
#     int index = 0;
#     int max_value = a0[0];
#     for (int i = 1; i < a2; ++i) {
#         if (max_value < a[i]) {
#             index = i;
#             max_value = a[i];
#         }
#     }
#     return index;
# }
# =================================================================
argmax:
    # Prologue
    addi sp, sp -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    # end
    addi t0, zero, 1
    blt a1, t0, error
    mv s0, a0
    mv s1, a1
    mv s2, zero         # index = 0
    lw s3, 0(s0)        # max_value = a0[0]
    addi s4, zero, 1    # int i = 1
loop_start:
    bge s4, s1, loop_end
if1:
    slli t0, s4, 2      # offset
    add t1, s0, t0      # base + offset
    lw t3, 0(t1)        # load a0[i]
    bge s3, t3, endif1
    mv s2, s4
    mv s3, t3
endif1:
    addi s4, s4, 1      # ++i
    j loop_start
loop_end:
    mv a0, s2
    j exit
error:
    addi a0, zero, 77
    j exit
exit:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20
    ret
