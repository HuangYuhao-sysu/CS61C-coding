#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

void transpose_one_block(int block_row, int block_col, int blocksize, int n, int *src, int *dst) {
    int start_dst = (block_row) * blocksize + (block_col) * n * blocksize;
    int start_src = (block_col) * blocksize + (block_row) * n * blocksize;
    //printf("Block row:  %d\nBlock col:  %d\nBlock size: %d\nTotal size: %d\n", block_row, block_col, blocksize, n);
    //printf("Start transpose one block.\n");
    for (int i = 0; i < blocksize; i++) {
        for (int j = 0; j < blocksize; j++) {
            dst[start_dst + j + i * n] = src[start_src + j * n + i];
            /* example: blocksize = 2, n = 6
             1. row = 0, col = 0, start_dst = 0, start_src = 0
             dst[0] = src[0]
             dst[1] = src[6]
             dst[6] = src[1]
             dst[7] = src[7]
             2. row = 0, col = 1, start_dst = 12, start_src = 2
             dst[12] = src[2]
             dst[13] = src[8]
             dst[18] = src[3]
             dst[19] = src[9]
             3. row = 2, col = 1, start_dst = 16, start_src = 26
             dst[16] = src[26]
             dst[17] = src[32]
             dst[22] = src[27]
             dst[23] = src[33]
            */
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
    int times = n / blocksize;
    for (int i = 0; i < times; i++) {
        for (int j = 0; j < times; j++) {
            transpose_one_block(i, j, blocksize, n, src, dst);
        }
    }
}