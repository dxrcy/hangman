#SingleInstance force

FileRead, file, words.txt
If ErrorLevel {
    MsgBox Cannot read words.txt
    ExitApp
}
words := StrSplit(file, "`r`n")

While true {
    Random index, 1, words.MaxIndex()
    word := words[index]
    correct := ""
    incorrect := ""

    While true {
        show := ""
        hasUnknown := false
        len := StrLen(word)
        Loop %len% {
            letter := SubStr(word, A_Index, 1)
            If InStr(correct, letter) {
                show .= letter
            } Else {
                hasUnknown := true
                show .= "_"
            }
        }

        If !hasUnknown {
            MsgBox , , Hangman, WIN
            Break
        }

        chances := 6 - StrLen(incorrect)
        InputBox guess, Hangman, %show%`nChances: %chances%`nCorrect: %correct%`nIncorrect: %incorrect%
        guess := SubStr(guess, 1, 1)

        If (guess == "") {
            Return
        }

        If InStr(word, guess) {
            if !InStr(correct, guess) {
                correct .= guess
            }
        } else {
            if !InStr(incorrect, guess) {
                incorrect .= guess
            }
        }

        If (StrLen(incorrect) >= 6) {
            MsgBox , , Hangman, LOSS`nThe word was '%word%'
            Break
        }
    }
}
