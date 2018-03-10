#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void reverse(
    unsigned char *list,
    unsigned int pos,
    unsigned int n
) {
    unsigned int m = n-- >> 1;

    for(int i = 0; i < m; ++i) {
        char tmp = list[(pos+i) % 256];
        list[(pos+i) % 256] = list[(pos+n-i) % 256];
        list[(pos+n-i) % 256] = tmp;
    }
}


void hash_sparse(
    unsigned char *list,
    unsigned char *buffer
) {
    unsigned int position = 0;
    unsigned int skip = 0;

    for(int round = 0; round < 64; ++round) {
        unsigned char *c = buffer;

        while(*c) {
            unsigned int n = *c++;

            reverse(list, position, n);
            position = (position + n + skip) % 256;
            skip += 1;
        }
    }
}


void hash_dense(
    unsigned char *dense,
    unsigned char *sparse
) {
    for(int i = 0; i < 16; ++i) {
        dense[i] = sparse[i * 16 +  0]
                 ^ sparse[i * 16 +  1]
                 ^ sparse[i * 16 +  2]
                 ^ sparse[i * 16 +  3]
                 ^ sparse[i * 16 +  4]
                 ^ sparse[i * 16 +  5]
                 ^ sparse[i * 16 +  6]
                 ^ sparse[i * 16 +  7]
                 ^ sparse[i * 16 +  8]
                 ^ sparse[i * 16 +  9]
                 ^ sparse[i * 16 + 10]
                 ^ sparse[i * 16 + 11]
                 ^ sparse[i * 16 + 12]
                 ^ sparse[i * 16 + 13]
                 ^ sparse[i * 16 + 14]
                 ^ sparse[i * 16 + 15];
    }
}


int count_set_bits(unsigned char *dense) {
    int count = 0;

    for(int i = 0; i < 16; ++i) {
        unsigned char n = dense[i];

        while(n) {
            count += n & 1;
            n >>= 1;
        }
    }

    return count;
}


void show_grid(unsigned char grid[]) {
    for(int i = 0; i < 128 * 16; ++i) {
        if(i != 0 && i % 16 == 0) printf("\n");
        for(int j = 0; j < 8; ++j) {
            printf("%u", grid[i] >> j & 1);
        }
        printf(" ");
    }
    printf("\n");
}


void remove_island(unsigned char grid[], int x, int y) {
    int byte = x / 8;
    int bit = 7 - (x - byte * 8); // reversed order

    if (grid[y * 16 + byte] >> bit & 1) {
        grid[y * 16 + byte] &= ~(1 << bit);
        if (x >   0) remove_island(grid, x - 1, y);
        if (x < 127) remove_island(grid, x + 1, y);
        if (y >   0) remove_island(grid, x, y - 1);
        if (y < 127) remove_island(grid, x, y + 1);
    }
}


int count_islands(unsigned char grid[]) {
    int count = 0;

    for(int y = 0; y < 128; ++y) {
        for (int x = 0; x < 128; ++x) {
            int byte = x / 8;
            int bit = 7 - (x - byte * 8); // reversed order

            if(grid[y * 16 + byte] >> bit & 1) {
                count++;
                remove_island(grid, x, y);
            }
        }
    }

    return count;
}


int main(void) {
    const char *input = "ugkiagan";
    unsigned int suffix = 4;
    unsigned char end[] = { 17, 31, 73, 47, 23, '\0' };

    unsigned char buffer[strlen(input) + suffix + sizeof(end)];
    char *suffix_start = buffer + strlen(input);
    memcpy(buffer, input, strlen(input));

    unsigned char list[256];
    unsigned char dense[16];
    unsigned char grid[128 * 16];

    for(int i = 0; i < 128; ++i) {

        sprintf(suffix_start, "-%u", i);
        size_t suffix_size = strlen(suffix_start);
        memcpy(suffix_start + suffix_size, end, sizeof(end));

        // reset the hashing for every row
        for(int i = 0; i < 256; ++i)
            list[i] = i;

        hash_sparse(list, buffer);
        hash_dense(dense, list);

        memcpy(grid + i * sizeof(dense), dense, sizeof(dense));
    }

    int answer = count_islands(grid);

    printf("%d\n", answer);

    return 0;
}
