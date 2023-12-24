#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "simd.h"

long long int sum(int vals[NUM_ELEMS]) {
    clock_t start = clock();

    long long int sum = 0;
    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        for(unsigned int i = 0; i < NUM_ELEMS; i++) {
            if(vals[i] >= 128) {
                sum += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    long long int sum = 0;

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
            if(vals[i] >= 128) sum += vals[i];
            if(vals[i + 1] >= 128) sum += vals[i + 1];
            if(vals[i + 2] >= 128) sum += vals[i + 2];
            if(vals[i + 3] >= 128) sum += vals[i + 3];
        }

        //This is what we call the TAIL CASE
        //For when NUM_ELEMS isn't a multiple of 4
        //NONTRIVIAL FACT: NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
        for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
            if (vals[i] >= 128) {
                sum += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    __m128i _127 = _mm_set1_epi32(127);        // This is a vector with 127s in it... Why might you need this?
    long long int result = 0;                   // This is where you should put your final result!
    /* DO NOT DO NOT DO NOT DO NOT WRITE ANYTHING ABOVE THIS LINE. */

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        /* YOUR CODE GOES HERE */
        __m128i tmp_result = _mm_setzero_si128();
        for (unsigned int i = 0; i < NUM_ELEMS / 8 * 8; i += 8) {
            __m128i val_0 = _mm_loadu_si128((__m128i*) (vals + i));
            __m128i val_4 = _mm_loadu_si128((__m128i*) (vals + i + 4));
            __m128i mask_0 = _mm_cmpgt_epi32(val_0, _127);
            __m128i mask_4 = _mm_cmpgt_epi32(val_4, _127);
            __m128i val_0_masked = _mm_and_si128(val_0, mask_0);
            __m128i val_4_masked = _mm_and_si128(val_4, mask_4);
            tmp_result += _mm_add_epi32(val_0_masked, val_4_masked);
        }

        int* tmp_result_p = (int*) (&tmp_result);
        for (int i = 0; i < 4; i++) {
            result += *(tmp_result_p + i);
        }

        /* You'll need a tail case. */
        for (unsigned i = NUM_ELEMS / 8 * 8; i < NUM_ELEMS; i++)
        {
            if (vals[i] >= 128)
            {
                result += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return result;
}

long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    __m128i _127 = _mm_set1_epi32(127);
    long long int result = 0;
    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        /* COPY AND PASTE YOUR sum_simd() HERE */
        /* MODIFY IT BY UNROLLING IT */
        __m128i tmp_result = _mm_setzero_si128();
        for (unsigned int i = 0; i < NUM_ELEMS / 32 * 32; i += 32) {
            __m128i val_0 = _mm_loadu_si128((__m128i*) (vals + i));
            __m128i val_4 = _mm_loadu_si128((__m128i*) (vals + i + 4));
            __m128i mask_0 = _mm_cmpgt_epi32(val_0, _127);
            __m128i mask_4 = _mm_cmpgt_epi32(val_4, _127);
            __m128i val_0_masked = _mm_and_si128(val_0, mask_0);
            __m128i val_4_masked = _mm_and_si128(val_4, mask_4);
            tmp_result += _mm_add_epi32(val_0_masked, val_4_masked);

            __m128i val_8 = _mm_loadu_si128((__m128i*) (vals + i + 8));
            __m128i val_12 = _mm_loadu_si128((__m128i*) (vals + i + 12));
            __m128i mask_8 = _mm_cmpgt_epi32(val_8, _127);
            __m128i mask_12 = _mm_cmpgt_epi32(val_12, _127);
            __m128i val_8_masked = _mm_and_si128(val_8, mask_8);
            __m128i val_12_masked = _mm_and_si128(val_12, mask_12);
            tmp_result += _mm_add_epi32(val_8_masked, val_12_masked);

            __m128i val_16 = _mm_loadu_si128((__m128i*) (vals + i + 16));
            __m128i val_20 = _mm_loadu_si128((__m128i*) (vals + i + 20));
            __m128i mask_16 = _mm_cmpgt_epi32(val_16, _127);
            __m128i mask_20 = _mm_cmpgt_epi32(val_20, _127);
            __m128i val_16_masked = _mm_and_si128(val_16, mask_16);
            __m128i val_20_masked = _mm_and_si128(val_20, mask_20);
            tmp_result += _mm_add_epi32(val_16_masked, val_20_masked);

            __m128i val_24 = _mm_loadu_si128((__m128i*) (vals + i + 24));
            __m128i val_28 = _mm_loadu_si128((__m128i*) (vals + i + 28));
            __m128i mask_24 = _mm_cmpgt_epi32(val_24, _127);
            __m128i mask_28 = _mm_cmpgt_epi32(val_28, _127);
            __m128i val_24_masked = _mm_and_si128(val_24, mask_24);
            __m128i val_28_masked = _mm_and_si128(val_28, mask_28);
            tmp_result += _mm_add_epi32(val_24_masked, val_28_masked);
        }

        int* tmp_result_p = (int*) (&tmp_result);
        for (int i = 0; i < 4; i++) {
            result += *(tmp_result_p + i);
        }

        /* You'll need a tail case. */
        for (unsigned i = NUM_ELEMS / 32 * 32; i < NUM_ELEMS; i++)
        {
            if (vals[i] >= 128)
            {
                result += vals[i];
            }
        }

        /* You'll need 1 or maybe 2 tail cases here. */

    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return result;
}
