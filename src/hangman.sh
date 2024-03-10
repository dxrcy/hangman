#!/bin/sh

main() {
    echo "=== HANGMAN ==="

    filename="$1"
    if [ -z "$filename" ]; then
        echo "Please provide a file path." >&2
        exit 1
    fi

    printf '\n\n\n\n\n\n'

    while true; do
        word="$(shuf -n1 "$filename" | tr -d '\r' | tr -d '\n')"
        correct=''
        incorrect=''

        while true; do
            i=0
            while [ "$i" -lt 5 ]; do
                i=$((i + 1))
                printf '\033[A\033[K'
            done
            
            visible=''
            is_win=1
            i=0
            while [ "$i" -lt "${#word}" ]; do
                i=$((i + 1))
                ch=$(echo "$word" | cut -c "$i")

                case "$correct" in
                    *"$ch"*)
                        visible="$visible$ch"
                        ;;
                    *)
                        visible="${visible}_"
                        is_win=0
                        ;;
                esac
            done

            if [ "$is_win" = 1 ]; then
                echo "---------"
                echo "You win! :)"
                printf "The word was: '%s'\n" "$word"
                echo "---------"
                read -r
                break
            fi
            if [ "${#incorrect}" -ge 6 ]; then
                echo "---------"
                echo "You lose! :("
                printf "The word was: '%s'\n" "$word"
                echo "---------"
                read -r
                break
            fi
            
            echo "$visible"
            echo 'Chances:' "$((6 - ${#incorrect}))"
            printf 'Correct: '
            string_separate "$correct"
            printf 'Incorrect: '
            string_separate "$incorrect"
            printf 'Guess: '

            read -r line
            if [ "${#line}" -lt 1 ]; then
                continue
            fi
            guess=$(echo "$line" | cut -c 1)

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
        done
    done
}

string_separate() {
    input="$1"
    i=0
    while [ "$i" -lt "${#input}" ]; do
        i=$((i + 1))
        if [ "$i" -gt 1 ]; then
            printf ', '
        fi
        ch=$(echo "$input" | cut -c "$i")
        printf '%s' "$ch"
    done
    echo
}

main "$@"

