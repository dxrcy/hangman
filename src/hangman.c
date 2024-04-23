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
        int cap = list->len + 10;
        char *new_data = realloc(list->data, cap * MAX_WORD_LEN);
        if (new_data == NULL) {
            perror("realloc failed.\n");
            exit(EXIT_FAILURE);
        }

        // Zero out new memory
        for (int i = list->cap; i < cap; i++) {
            new_data[i * MAX_WORD_LEN] = '\0';
        }

        list->cap = cap;
        list->data = new_data;
    }

    strcpy(&list->data[list->len * MAX_WORD_LEN], data);
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

void print_char_list(char *string) {
    char ch;
    for (int i = 0; (ch = string[i]) != '\0'; i++) {
        if (i > 0) {
            printf(", ");
        }
        printf("%c", ch);
    }
    printf("\n");
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

    printf("\n\n\n\n\n\n");

    while (1) {
        int index = rand() % words.len;
        char word[MAX_WORD_LEN] = "";
        char ch;
        for (int i = 0; (ch = words.data[i + index * MAX_WORD_LEN]) != '\0';
             i++) {
            word[i] = ch;
        }

        char correct[26] = "";
        char incorrect[26] = "";

        while (1) {
            for (int i = 0; i < 5; i++) {
                printf("\x1b[A\x1b[K");
            }

            char visible[MAX_WORD_LEN] = "";
            char ch;
            char is_win = 1;
            for (int i = 0; (ch = word[i]) != '\0'; i++) {
                if (strchr(correct, ch) != NULL) {
                    visible[i] = ch;
                } else {
                    visible[i] = '_';
                    is_win = 0;
                }
            }

            int correct_len = strlen(correct);
            int incorrect_len = strlen(incorrect);

            if (is_win) {
                printf("---------\n");
                printf("You win! :)\n");
                printf("The word was: '%s'\n", word);
                printf("---------\n");
                getchar();
                break;
            }
            if (incorrect_len >= 6) {
                printf("---------\n");
                printf("You lose! :(\n");
                printf("The word was: '%s'\n", word);
                printf("---------\n");
                getchar();
                break;
            }

            printf("%s\n", visible);
            printf("Chances: %d\n", 6 - incorrect_len);
            printf("Correct: ");
            print_char_list(correct);
            printf("Incorrect: ");
            print_char_list(incorrect);
            printf("Guess: ");

            char guess = getchar();
            if (guess == '\n') {
                continue;
            }
            while (getchar() != '\n')
                ;

            if (strchr(word, guess) != NULL) {
                if (strchr(correct, guess) == NULL) {
                    correct[correct_len] = guess;
                    correct[correct_len + 1] = '\0';
                }
            } else {
                if (strchr(incorrect, guess) == NULL) {
                    incorrect[incorrect_len] = guess;
                    incorrect[incorrect_len + 1] = '\0';
                }
            }
        }
    }

    // Never executed?
    free(words.data);
}
