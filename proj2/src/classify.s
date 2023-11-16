.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    # int classify (int argc, char** argv, int a2) {
    #     if (argc != 5) {
    #         exit(89);
    #     }
    #     char* m0_path = argv[1];
    #     char* m1_path = argv[2];
    #     char* input_path = argv[3];
    #     char* output_path = argv[4];
    #     int print_c = a2;
    #     
    #     // Load matrices
    #     int* m0_rows_p = malloc(sizeof(int));
    #     int* m0_cols_p = malloc(sizeof(int));
    #     int* m0 = read_matrix(m0_path, m0_rows_p, m0_cols_p);
    #     int* m1_rows_p = malloc(sizeof(int));
    #     int* m1_cols_p = malloc(sizeof(int));
    #     int* m1 = read_matrix(m1_path, m1_rows_p, m1_cols_p);
    #     int* input_rows_p = malloc(sizeof(int));
    #     int* input_cols_p = malloc(sizeof(int));
    #     int* input = read_matrix(input_path, input_rows_p, input_cols_p);
    #     
    #     // Network
    #     int h_num = *m0_rows_p * *input_cols_p;
    #     int* hidden_layer = malloc(sizeof(int) * h_num);
    #     matmul(m0, *m0_rows_p, *m0_cols_p, input, *input_rows_p, *input_cols_p, hidden_layer);
    #     relu(hidden_layer, h_num);
    #     int s_num = *m1_rows_p * *input_cols_p;
    #     int* score = malloc(sizeof(int) * s_num);
    #     matmul(m1, *m1_rows_p, *m1_cols_p, hidden_layer, *m0_rows_p, *input_cols_p, score);
    # 
    #     // Write result
    #     write_matrix(output_path, score, *m1_rows_p, *input_cols_p);
    #     
    #     int c = argmax(score, s_num);
    #     if (print_c == 0) {
    #         print_int(x, c);
    #     }
    #     return c;
    # }
    # Prologue
    addi sp, sp, -52
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
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)
    # end
    addi t0, zero, 5
    bne a0, t0, error_89
    lw s0, 4(a1)                # char* m0_path = argv[1]
    lw s1, 8(a1)                # char* m1_path = argv[2]
    lw s2, 12(a1)               # char* input_path = argv[3]
    lw s3, 16(a1)               # char* output_path = argv[4]
    mv s4, a2                   # int print_c = a2
    # =====================================
    # LOAD MATRICES
    # =====================================
    # Load pretrained m0
    addi a0, zero, 4
    jal malloc
    beq a0, zero, error_88
    mv s5, a0                   # int* m0_rows_p = malloc
    addi a0, zero, 4
    jal malloc
    beq a0, zero, error_88
    mv s6, a0                   # int* m0_cols_p = malloc
    mv a0, s0
    mv a1, s5
    mv a2, s6
    jal read_matrix
    mv s7, a0                   # m0 = read_matrix(m0_path, m0_rows_p, m0_cols_p);
    # Load pretrained m1
    addi a0, zero, 4
    jal malloc
    beq a0, zero, error_88
    mv s8, a0                   # int* m1_rows_p = malloc
    addi a0, zero, 4
    jal malloc
    beq a0, zero, error_88
    mv s9, a0                   # int* m1_cols_p = malloc
    mv a0, s1
    mv a1, s7
    mv a2, s8
    jal read_matrix
    mv s10, a0                   # m1 = read_matrix(m1_path, m1_rows_p, m1_cols_p);
    # Load input matrix
    addi a0, zero, 4
    jal malloc
    beq a0, zero, error_88
    mv s11, a0                  # int* input_rows_p = malloc
    addi a0, zero, 4
    jal malloc
    beq a0, zero, error_88
    mv s0, a0                   # int* input_cols_p = malloc
    mv a0, s2
    mv a1, s10
    mv a2, s11
    jal read_matrix
    mv s1, a0                   # input = read_matrix(input_path, input_rows_p, input_cols_p);
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    lw t0, 0(s5)
    lw t1, 0(s0)
    mul t2, t0, t1
    slli t2, t2, 2
    mv a0, t2
    jal malloc
    beq a0, zero, error_88
    mv s2, a0                   # int* hidden_layer = malloc(sizeof(int) * h_num);
    mv a0, s7
    lw a1, 0(s5)
    lw a2, 0(s6)
    mv a3, s1
    lw a4, 0(s11)
    lw a5, 0(s0)
    mv a6, s2
    jal matmul
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    lw t0, 0(s5)
    lw t1, 0(s0)
    mul t2, t0, t1
    mv a0, s2
    mv a1, t2
    jal relu
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 0(s8)
    lw t1, 0(s0)
    mul t2, t0, t1
    slli t2, t2, 2
    mv a0, t2
    jal malloc
    beq a0, zero, error_88
    mv s6, a0                   # int* score = malloc(sizeof(int) * s_num);
    mv a0, s10
    lw a1, 0(s8)
    lw a2, 0(s9)
    mv a3, s2
    lw a4, 0(s5)
    lw a5, 0(s0)
    mv a6, s6
    jal matmul                  # score = matmul(m1, hidden_layer)
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0, s3
    mv a1, s6
    lw a2, 0(s8)
    lw a3, 0(s0)
    jal write_matrix
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s6
    lw t0, 0(s8)
    lw t1, 0(s0)
    mul t2, t0, t1
    mv a1, t2
    jal argmax
    mv s0, a0                   # int c = argmax(score, s_num);
    # Print classification
    bne s4, zero, end
    mv a1, s0
    jal print_int
    # Print newline afterwards for clarity
    addi a1, zero, 10
    jal print_char
error_88:
    addi a1, zero, 88
    jal exit2
error_89:
    addi a1, zero, 89
    jal exit2
end:
    mv a0, s0
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
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    # end
    ret
