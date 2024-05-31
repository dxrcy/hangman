require "set"

def main()
    puts "=== HANGMAN ==="

    if ARGV.length < 1
        puts "Please provide a file path."
        exit 1
    end
    filename =  ARGV[0]

    begin
        file = File.new(filename, "r").read
    rescue
        puts "Failed to read file."
        exit 2
    end
    words = file.split("\n")

    puts "\n\n\n\n\n\n"

    loop do
        index = rand(0..(words.length - 1))
        word = words[index]
        correct = Set.new
        incorrect = Set.new

        loop do
            for _ in 1..5
                print "\033[A\033[K"
            end

            visible = ""
            is_win = true
            word.each_char do |ch|
                if correct.include? ch
                    visible += ch
                else
                    visible += "_"
                    is_win = false
                end
            end

            if is_win
                puts "---------"
                puts "You win! :)"
                puts "The word was: '#{word}'"
                puts "---------"
                STDIN.gets.chomp
                break;
            end
            if incorrect.length >= 6
                puts "---------"
                puts "You lose! :("
                puts "The word was: '#{word}'"
                puts "---------"
                STDIN.gets.chomp
                break;
            end

            puts visible
            puts "Chances: " + (6 - incorrect.length).to_s
            puts "Correct: " + correct.to_a.join(", ")
            puts "Incorrect: " + incorrect.to_a.join(", ")
            print "Guess: "

            line = STDIN.gets.chomp
            if line.length < 1
                next
            end
            guess = line[0]
            
            if word.include? guess
                correct.add(guess)
            else
                incorrect.add(guess)
            end
        end
    end
end

main()

