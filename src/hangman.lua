local function main()
    print("=== HANGMAN ===")

    if #arg < 1 then
        print("Please provide a file path.")
        os.exit(1)
    end
    local filename = arg[1]

    local words = ReadFileLines(filename)
    if words == nil then
        print("Failed to read file.")
        os.exit(2)
    end

    print("\n\n\n\n\n")

    while true do
        local index = math.random(1, #words)
        local word = words[index]

        local correct = ""
        local incorrect = ""

        while true do
            for _ = 1, 5 do
                io.write("\033[A\033[K");
            end

            local visible = ""
            local is_win = true
            for i = 1, #word do
                local ch = word:sub(i, i)
                if string.find(correct, ch) then
                    visible = visible .. ch
                else
                    visible = visible .. "_"
                    is_win = false
                end
            end

            if is_win then
                print("---------")
                print("You win! :)")
                print("The word was: '" .. word .. "'")
                print("---------")
                _ = io.read()
                break
            end
            if #incorrect >= 6 then
                print("---------")
                print("You lose! :(")
                print("The word was: '" .. word .. "'")
                print("---------")
                _ = io.read()
                break
            end

            print(visible)
            print("Chances: " .. (6 - #incorrect))
            print("Correct: " .. StringSeparate(correct))
            print("Incorrect: " .. StringSeparate(incorrect))
            io.write("Guess: ")

            local line = io.read()
            if #line >= 1 then
                local guess = line:sub(1, 1)

                if string.find(word, guess) then
                    if not string.find(correct, guess) then
                        correct = correct .. guess
                    end
                else
                    if not string.find(incorrect, guess) then
                        incorrect = incorrect .. guess
                    end
                end
            end
        end
    end
end

function ReadFileLines(filename)
    local file = io.open(filename, "r")
    if file == nil then
        return
    end

    local lines = {}
    for line in file:lines() do
        if line:sub(-1) == "\r" then
            line = line:sub(1, -2)
        end
        table.insert(lines, line)
    end
    file:close()

    return lines
end

function StringSeparate(input)
    local output = ""
    for i = 1, #input do
        if i > 1 then
            output = output .. ", "
        end
        output = output .. input:sub(i, i)
    end
    return output
end

main()

