.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# int* read_matrix(a0, a1, a2) {
#     char* filename = a0;
#     int* rows_p = a1;
#     int* cols_p = a2;
#     int file_p = fopen(filename, 0);
#     if (file_p == -1) {
#         exit(90);
#     }
#     int check_rows = fread(file_p, rows_p, 4);
#     int check_cols = fread(file_p, cols_p, 4);
#     if (check_rows != 4 || check_cols != 4) {
#         exit(91);
#     }
#     int read_num = *rows_p * *cols_p;
#     int* matrix_result = (int*) malloc(sizeof(int) * read_num);
#     if (matrix_result == NULL) {
#         exit(88);
#     }
#     int check_matrix = fread(file_p, matrix_result, read_num);
#     if (check_matrix != read_num) {
#         exit(91);
#     }
#     int check_fclose = fclose(file_p);
#     if (check_fclose != 0) {
#         exit(92)
#     }
#     return matrix_result;
# }
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    # end
    mv s0, a0               # char * filename = a0;
    mv s1, a1               # int* rows_p = a1;
    mv s2, a2               # int* cols_p = a2;
    mv a1, s0
    mv a2, zero             # Set argument for fopen
    jal fopen
    mv s3, a0               # int file_p = fopen(*)
    addi t0, zero, -1
    beq s3, t0, error_90    # exit with 90
    mv a1, s3
    mv a2, s1
    addi a3, zero, 4
    jal fread               # call fread for rows_p
    addi t0, zero, 4
    bne t0, a0, error_91    # exit with 91
    mv a1, s3
    mv a2, s2
    addi a3, zero, 4
    jal fread               # call fread for cols_p
    addi t0, zero, 4
    bne t0, a0, error_91    # exit with 91
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul s4, t0, t1          # int read_num = rows*cols
    slli a0, s4, 2          # number of bytes need to alloc
    jal malloc
    mv s5, a0               # int* matrix_result = malloc(*)
    beq s5, zero, error_88  # exit with 88
    mv a1, s3
    mv a2, s5
    slli t0, s4, 2
    mv a3, t0
    jal fread               # call fread for matrix_result
    slli t0, s4, 2
    bne t0, a0, error_91    # exit with 91
    mv a1, s3
    jal fclose              # close file
    bne a0, zero, error_92  # exit with 92
    mv a0, s5
    j exit
error_88:
    addi a1, zero, 88
    jal exit2
error_90:
    addi a1, zero, 90
    jal exit2
error_91:
    addi a1, zero, 91
    jal exit2
error_92:
    addi a1, zero, 92
    jal exit2
exit:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp 28
    # end
    ret