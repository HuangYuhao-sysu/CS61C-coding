#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t result_bit;
    result_bit = ((get_bit(*reg, 0) ^ get_bit(*reg, 2)) ^ get_bit(*reg, 3)) ^ get_bit(*reg, 5);
    *reg = *reg >> 1;
    set_bit(reg, 15, result_bit);
}

uint16_t get_bit(uint16_t x, uint16_t n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns 
    // 0 or 1)
    return (x >> n) & 0x00000001;
}

// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(uint16_t * x, uint16_t n, uint16_t v) {
    // YOUR CODE HERE
    *x = v ? (0x00000001 << n) | *x : (~(0x00000001 << n)) & *x;
}