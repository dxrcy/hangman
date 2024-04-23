#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_WORD_LEN 20

struct list {
    char *data;
    int len;
    int cap;
};

struct list list_new(int cap) {
    struct list list;
    list.len = 0;
    list.cap = cap;

    list.data = calloc(cap, MAX_WORD_LEN);
    if (list.data == NULL) {
        perror("calloc failed.\n");
        exit(EXIT_FAILURE);
    }

    return list;
}

void list_push(struct list *list, char data[MAX_WORD_LEN]) {
    // Resize allocated array
    if (list->len >= list->cap) {
        int prev_cap = list->cap;
        list->cap = list->len + 10;

        char *new_data = realloc(list->data, list->cap * MAX_WORD_LEN);
        if (new_data == NULL) {
            perror("realloc failed.\n");
            exit(EXIT_FAILURE);
        }

        // Zero out new memory
        for (int i = prev_cap * MAX_WORD_LEN; i < list->cap * MAX_WORD_LEN;
             i++) {
            new_data[i] = 0;
        }

        list->data = new_data;
    }

    for (int i = 0; i < MAX_WORD_LEN; i++) {
        // This is complicated!
        ((char *)list->data)[list->len * MAX_WORD_LEN + i] = data[i];
        if (data[i] == '\0') {
            break;
        }
    }

    list->len++;
}

struct list read_file_lines(FILE *fd) {
    struct list lines = list_new(10);

    int ch = 0;
    while (ch != EOF) {
        char line[MAX_WORD_LEN] = "";

        for (int i = 0; i < MAX_WORD_LEN; i++) {
            ch = fgetc(fd);
            if (ch == '\n' || ch == EOF) {
                break;
            }
            line[i] = ch;
        }

        if (line[0] != '\0') {
            list_push(&lines, line);
        }
    }

    return lines;
}

void print_list(struct list *list) {
    printf("len:%d cap:%d\n", list->len, list->cap);
    for (int i = 0; i < list->len; i++) {
        printf("%2d: <", i);
        for (int j = 0; j < MAX_WORD_LEN; j++) {
            printf("%c", list->data[i * MAX_WORD_LEN + j]);
        }
        printf(">\n");
    }
}

int main(int argc, char **argv) {
    printf("=== HANGMAN ===\n");

    if (argc < 2) {
        fprintf(stderr, "Please provide a file path.\n");
        return 1;
    }

    FILE *fd = fopen(argv[1], "r");
    if (fd == NULL) {
        fprintf(stderr, "Failed to read file.\n");
        return 2;
    }

    struct list words = read_file_lines(fd);
    fclose(fd);

    srand(time(NULL));

    int index = rand() % words.len;
    char word[MAX_WORD_LEN] = "";
    char ch;
    for (int i = 0; (ch = words.data[i + index * MAX_WORD_LEN]) != '\0'; i++) {
        word[i] = ch;
    }

    printf("%s\n", word);

    free(words.data);
}

