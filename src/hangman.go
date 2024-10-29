package main

import (
	"bufio"
	"fmt"
	"log"
	"math/rand"
	"os"
	"strings"
)

func main() {
	fmt.Println("=== HANGMAN ===")

	stderr := log.New(os.Stderr, "", 0)

	if len(os.Args) < 2 {
		stderr.Println("Please provide a file path.")
		os.Exit(1)
	}
	filename := os.Args[1]

	file, err := os.ReadFile(filename)
	if err != nil {
		stderr.Println("Failed to read file.")
		os.Exit(2)
	}
	words := strings.Split(string(file), "\n")

	scanner := bufio.NewScanner(os.Stdin)

	fmt.Print("\n\n\n\n\n\n")

	for {
		index := rand.Intn(len(words))
		word := strings.TrimSpace(words[index])

		correct := make(map[rune]bool)
		incorrect := make(map[rune]bool)

		for {
			for i := 0; i < 5; i++ {
				fmt.Print("\033[A\033[K")
			}

			visible := ""
			is_win := true
			for _, ch := range word {
				if correct[ch] {
					visible += string(ch)
				} else {
					visible += "_"
					is_win = false
				}
			}

			if is_win {
				fmt.Println("---------")
				fmt.Println("You win! :)")
				fmt.Printf("The word was: '%s'\n", word)
				fmt.Println("---------")
				scanner.Scan()
				break
			}
			if len(incorrect) >= 6 {
				fmt.Println("---------")
				fmt.Println("You lose! :(")
				fmt.Printf("The word was: '%s'\n", word)
				fmt.Println("---------")
				scanner.Scan()
				break
			}

			fmt.Println(visible)
			fmt.Printf("Chances: %d\n", 6-len(incorrect))
			fmt.Print("Correct: ")
			printSet(correct)
			fmt.Print("Incorrect: ")
			printSet(incorrect)
			fmt.Print("Guess: ")

			var line string
			fmt.Scanln(&line)
			if len(line) < 1 {
				continue
			}
			guess := []rune(line)[0]

			if strings.ContainsRune(word, guess) {
				correct[guess] = true
			} else {
				incorrect[guess] = true
			}
		}
	}
}

func printSet(set map[rune]bool) {
	i := 0
	for ch, _ := range set {
		if i > 0 {
			fmt.Print(", ")
		}
		fmt.Printf("%c", ch)
		i++
	}
	fmt.Println()
}
