.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# void write_matrix(char* a0, int* a1, int a2, int a3) {
#     char* filename = a0;
#     int* matrix = a1;
#     int* rows_p = malloc(sizeof(int));
#     int* cols_p = malloc(sizeof(int));
#     *rows_p = a2;
#     *cols_p = a3;
#     int file_p = fopen(x, filename, 1);
#     if (file_p == -1) {
#         exit(93);
#     }
#     fwrite(file_p, rows_p, 1, 4);
#     fwrite(file_p, cols_p, 1, 4);
#     fwrite(file_p, matrix, rows*cols, 4)
#     // check, exit(94)
#     fclose(file_p);
#     // check exit(95)
# }
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    # end
    mv s0, a0           # char* filename = a0;
    mv s1, a1           # int* matrix = a1;
    mv s2, a2
    mv s3, a3
    addi a0, zero, 4
    jal malloc
    mv s4, a0           # int* rows_p = malloc
    addi a0, zero, 4
    jal malloc
    mv s5, a0           # int* cols_p = malloc
    sw s2 0(s4)
    sw s3 0(s5)         # *rows_p = a2, *cols_p = a3
    mv a1, s0
    addi a2, zero, 1
    jal fopen
    mv s6, a0           # int file_p = fopen
    addi t0, zero, -1
    beq a0, t0, error_93
    mv a1, s6
    mv a2, s4
    addi a3, zero, 1
    addi a4, zero, 4
    jal fwrite
    addi t0, zero, 1
    blt a0, t0, error_94
    mv a1, s6
    mv a2, s5
    addi a3, zero, 1
    addi a4, zero, 4
    jal fwrite
    addi t0, zero, 1
    blt a0, t0, error_94
    mv a1, s6
    mv a2, s1
    mul a3, s2, s3
    addi a4, zero, 4
    jal fwrite
    mul t0, s2, s3
    blt a0, t0, error_94
    mv a1, s6
    jal fclose
    bne a0, zero, error_95
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    # end
    j exit
error_93:
    addi a1, zero, 93
    j exit2
error_94:
    addi a1, zero, 94
    j exit2
error_95:
    addi a1, zero, 95
    j exit2
