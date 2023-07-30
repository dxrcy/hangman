package main

import (
    "fmt"
    "os"
    "strings"
    "math/rand"
)

func main() {
    fmt.Println("\n=== Hangman ===")

    file, err := os.ReadFile("words.txt")
    if err != nil {
        panic("failed to read file")
    }
    words := strings.Split(string(file), "\n")

    for {
        word := strings.TrimSpace(words[rand.Intn(len(words))])

        correct, incorrect:= "", ""

        for {
            show := ""
            for _, letter := range word {
                if strings.Contains(correct, string(letter)) {
                    show += string(letter)
                } else {
                    show += "_"
                }
            }

            if show == word {
                print ("\n========\n   WIN\n========")
                break
            }

            fmt.Printf(
                "\n%s\nChances: %d\nCorrect: %s\nIncorrect: %s\n",
                show,
                6 - len(incorrect),
                correct,
                incorrect,
            )

            fmt.Print("Guess: ")
            var guess string
            fmt.Scanln(&guess)

            if strings.Contains(word, guess) {
                if !strings.Contains(correct, guess) {
                    correct += guess
                }
            } else {
                if !strings.Contains(correct, guess) {
                    incorrect += guess
                }
            }

            if len(incorrect) >= 6 {
                fmt.Printf(
                    "\n========\n  LOSS\n  The word was '%s'\n========\n",
                    word,
                )
                break
            }
        }
    }
}

