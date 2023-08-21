#!/bin/sh

printf '\n=== Hangman ===\n'

while true; do
    word=$(shuf -n 1 'words.txt' | tr -d '\r' | tr -d '\n')
    correct=''
    incorrect=''

    while true; do
        show=''

        length=${#word}
        i=0
        while [ "$i" -lt "$length" ]; do
            i=$((i + 1))
            letter=$(echo "$word" | cut -c "$i")

            case "$correct" in
                *"$letter"*)
                    show="$show$letter" ;;
                *)
                    show="${show}_" ;;
            esac
        done

        if [ "$show" = "$word" ]; then
            printf '\n========\n   WIN\n========\n'
            break
        fi

        length="${#incorrect}"
        chances=$((6 - length))
    
        printf '\n%s\nChances: %s\nCorrect: %s\nIncorrect: %s\n' "$show" "$chances" "$correct" "$incorrect"

        printf 'Guess: '
        read -r guess

        case "$word" in
            *"$guess"*)
                case "$correct" in
                    *"$guess"*) ;;
                    *)
                        correct="$correct$guess" ;;
                esac
                ;;
            *)
                case "$incorrect" in
                    *"$guess"*) ;;
                    *)
                        incorrect="$incorrect$guess" ;;
                esac
                ;;
        esac

        if [ "${#incorrect}" -ge 6 ]; then
            printf "\n========\n  LOSS\n  The word was '%s'\n========\n" "$word"
            break
        fi
    done
done

