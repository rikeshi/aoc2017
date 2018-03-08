#include <stdio.h>
#include <stdlib.h>

typedef struct node {
  int val;
  struct node *ptr;
} node;

node *insert_node(node *cur, int i) {
    node *new = (node*)malloc(sizeof(node));
    new->val = i;
    new->ptr = cur->ptr;
    cur->ptr = new;
    return new;
}

int main(void) {
    int step = 316;
    int bufsize = 1;

    // current node
    node *cur = (node*)malloc(sizeof(node));
    cur->val = 0;
    cur->ptr = cur;

    // fill circular buffer
    while (bufsize < 2018) {
        for(int i = 0; i < step % bufsize; ++i) {
            cur = cur->ptr;
        }
        cur = insert_node(cur, bufsize++);
    }

    printf("%d\n", cur->ptr->val);

    // free circular buffer
    node *ptr = cur->ptr;
    cur->ptr = 0;
    while (ptr) {
        cur = ptr;
        ptr = cur->ptr;
        free(cur);
    }

    return 0;
}
