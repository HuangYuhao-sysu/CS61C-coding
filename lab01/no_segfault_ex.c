#include <stdio.h>
int main() {
    int a[5] = {1, 2, 3, 4, 5};
    unsigned total = 0;
    int number = sizeof(a);
    printf("sizeof(a) == %d", number);
    for (int j = 0; j < number; j++) {
        total += a[j];
    }
    printf("sum of array is %d\n", total);
}
