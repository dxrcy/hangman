#include "stdio.h"
#include "stdlib.h"

int main() {
    printf("\n=== Hangman ===\n");

    FILE *file = fopen("words.txt", "r");

    if (file == NULL) {
        perror("Error reading file");
        return 1;
    }

    char **lines = NULL;
    size_t num_lines = 0;
    char buf
}

