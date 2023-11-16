.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# int matmul(int* a0, int a1, int a2, int* a3, int a4, int a5, int* a6) {
#     if (a1 < 1 || a2 < 1) {
#         return 72;
#     }
#     if (a4 < 1 || a5 < 1) {
#         return 73;
#     }
#     if (a2 != a4) {
#         return 74;
#     }
#     int* A = a0;
#     int  m = a1;
#     int  n = a2;
#     int* B = a3;
#     int  n = a4;
#     int  p = a5;
#     for (int i = 0; i < m; ++i) {
#         for (int j = 0; j < p; ++j) {
#             a6[i*p + j] = dot(A, B, n, 1, p);
#             B += 1;
#         }
#         A += n;
#         B = a3;
#     }
#     return 0;
# }
# =======================================================
matmul:
    # Error checks
    addi t0, zero 1
    blt a1, t0, error1
    blt a2, t0, error1
    blt a4, t0, error2
    blt a5, t0, error2
    bne a2, a4, error3
    # Prologue
    addi sp, sp, -44
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw ra, 40(sp)
    # end
    mv s0, a0   # int* A = a0;
    mv s1, a1   # int  m = a1;
    mv s2, a2   # int  n = a2;
    mv s3, a3   # int* B = a3;
    mv s4, a4   # int  n = a4;
    mv s5, a5   # int  p = a5;
    mv s6, a6   # int* C = a6;
    mv s9, a3   # static pointer to B
    mv s7, zero # int  i = 0;
outer_loop_start:
    bge s7, s1, outer_loop_end
    mv s8, zero # int  j = 0;
inner_loop_start:
    bge s8, s5, inner_loop_end
    mv a0, s0
    mv a1, s3
    mv a2, s4
    addi a3, zero, 1
    mv a4, s5
    jal dot
    mul t0, s7, s5
    add t0, t0, s8
    slli t0, t0 2
    add t0, s6, t0  # base + offset
    sw a0 0(t0)     # a6[i*p + j] = ...
    addi s3, s3, 4
    addi s8, s8, 1
    j inner_loop_start
inner_loop_end:
    mv t0, s4
    slli t0, t0, 2
    add s0, s0, t0
    mv s3, s9
    addi s7, s7, 1
    j outer_loop_start
outer_loop_end:
    mv a0, zero
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
    lw s9, 36(sp) 
    lw ra, 40(sp) 
    addi sp, sp, 44
    # end
    j exit
error1:
    addi a1, zero, 72
    j exit2
error2:
    addi a1, zero, 73
    j exit2
error3:
    addi a1, zero, 74
    j exit2