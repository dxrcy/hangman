import random
import sys


def main():
    print("=== HANGMAN ===")

    if len(sys.argv) < 2:
        print("Please provide a file path.", file=sys.stderr)
        sys.exit(1)
    filename = sys.argv[1]

    try:
        file = open(filename, "r").read()
    except Exception:
        print("Failed to read file.", file=sys.stderr)
        sys.exit(2)

    words = []
    for line in file.split("\n"):
        line = line.strip()
        if len(line) > 0:
            words.append(line)

    print("\n\n\n\n\n")

    while True:
        index = random.randint(0, (len(words) - 1))
        word = words[index]

        correct = set()
        incorrect = set()

        while True:
            for i in range(0, 5):
                print("\033[A\033[K", end="")

            visible = ""
            is_win = True
            for ch in word:
                if ch in correct:
                    visible += ch
                else:
                    visible += "_"
                    is_win = False

            if is_win:
                print("---------")
                print("You win! :)")
                print(f"The word was: '{word}'")
                print("---------")
                input()
                break
            if len(incorrect) >= 6:
                print("---------")
                print("You lose! :(")
                print(f"The word was: '{word}'")
                print("---------")
                input()
                break

            print(visible)
            print("Chances:", 6 - len(incorrect))
            print("Correct:", ", ".join(correct))
            print("Incorrect:", ", ".join(incorrect))

            line = input("Guess: ")
            if len(line) < 1:
                continue
            guess = line[0]

            if guess in word:
                correct.add(guess)
            else:
                incorrect.add(guess)


if __name__ == "__main__":
    main()
