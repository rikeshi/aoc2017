/*
 *  the first letters are KGPTEJ, final is S
 */

#include <stdio.h>
#include <stdlib.h>

typedef enum direction {
    LEFT  = -1,
    RIGHT =  1,
    UP    = -2,
    DOWN  =  2,
} direction;

typedef struct packet {
    int x;
    int y;
    direction d;
} packet;

int start(const char buf[]) {
    int i = -1;
    while(buf[++i] != '|') {}
    return i;
}

void move(packet *p) {
    switch(p->d) {
        case LEFT:
        case RIGHT:
            p->x += p->d;
            break;
        case UP:
        case DOWN:
            p->y += p->d >> 1;
            break;
    }
}

void check(const char buf[], size_t cols, packet *p) {
    char c = buf[p->y * cols + p->x];
    // have we found a letter?
    if (c > '@' && c < '[') {
        printf("%c", c);
    }
    // update direction
    if (c == '+') {
        char l;
        char r;
        switch(p->d) {
            case LEFT:
            case RIGHT:
                l = buf[(p->y - 1) * cols + p->x];
                r = buf[(p->y + 1) * cols + p->x];
                break;
            case UP:
            case DOWN:
                l = buf[p->y * cols + p->x - 1];
                r = buf[p->y * cols + p->x + 1];
                break;
        }
        if      (l == '|' || l == '-') p->d = -(l == '|') - 1;
        else if (r == '|' || r == '-') p->d =  (r == '|') + 1;
    }
    if (c == ' ') {
        //Done, exit
        printf("\n");
        exit(1);
    }
}

int main(void) {

    const size_t rows = 201;
    const size_t cols = 202;

    char buffer[rows * cols];

    FILE *fp = fopen("input", "r");
    size_t read = fread(&buffer, rows, cols, fp);
    fclose(fp);

    buffer[rows * cols - 1] = '\0';

    packet pacman;
    pacman.x = start(buffer);
    pacman.y = 0;
    pacman.d = DOWN;

    while (1) {
        move(&pacman);
        check(buffer, cols, &pacman);
    }

    return 0;

}
