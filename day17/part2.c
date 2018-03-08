#include <stdio.h>

int main(void) {
    const int step = 316;
    int result = 0;
    int position = 0;

    for (int i = 1; i <= 50000000; i++) {
        position = (position + step) % i + 1;
        if(position == 1) result = i;
    }

    printf("%d\n", result);

    return 0;
}
