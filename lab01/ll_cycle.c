#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *tortoise = head;
    node *hare = head;
    return find_cyclic(tortoise, hare);
}

int find_cyclic(node *tortoise, node *hare) {
    if (hare == NULL) {
        return 0;
    } else {
        hare = hare->next;
        if (hare == NULL) {
            return 0;
        }
        hare = hare->next;
        tortoise = tortoise->next;
        if (tortoise == hare) {
            return 1;
        }
        return find_cyclic(tortoise, hare);
    }
}
