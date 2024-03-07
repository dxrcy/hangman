print("\n=== Hangman ===")

-- Read lines of file into table
function file_lines(filename)
    local file = io.open(filename, "r")

    local lines = {}
    for line in file:lines() do
        -- Remove trailing newline
        line = line:gsub("[\r\n]", "")
        table.insert(lines, line)
    end
    file:close()

    return lines
end

-- Read words from fileb
local words = file_lines("words.txt")

while true do
    -- Get random word
    local word = words[math.random(1, #words)]

    local correct = ""
    local incorrect = ""

    while true do
        -- Show current guessed letters status
        local show = ""
        for letter in word:gmatch(".") do
            -- Show letter if in 'correct'
            show = show ..
                (string.find(correct, letter) and letter or "_")
        end

        -- Word is guessed - win
        if show == word then
            print ("\n========\n   WIN\n========")
            break
        end

        -- Show game state
        print(string.format(
            "\n%s\nChances: %d\nCorrect: %s\nIncorrect: %s",
            show,
            6 - #incorrect,
            correct,
            incorrect
        ))

        -- Read guess from stdin
        io.write("Guess: ")
        local guess = io.read()

        -- Guess is correct
        if string.find(word, guess) then
            -- Add to 'correct' if not already guessed
            if not string.find(correct, guess) then
                correct = correct .. guess
            end
        else
            -- Add to 'incorrect' if not already guessed
            if not string.find(incorrect, guess) then
                incorrect = incorrect .. guess
            end
        end

        -- No more chances - loss
        if #incorrect >= 6 then
            print(string.format(
                "\n========\n  LOSS\n  The word was '%s'\n========",
                word
            ))
            break
        end
    end

end

