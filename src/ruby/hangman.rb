puts "=== Hangman ==="
words = File.new("words.txt", "r").read.split("\n")

loop do
  word = words[rand(0..(words.length - 1))]
  correct = ""
  incorrect = ""

  loop do

    show = ""
    for i in 0..(word.length - 1)
      if correct.include? word[i]
        show += word[i]
      else
        show += "_"
      end
    end
    
    if show == word
      puts "\n========\n   WIN\n========\n"
      break
    end
    
    print "\n", show, "\nChances: ", 6 - incorrect.length, "\nCorrect: ", correct, "\nIncorrect: ", incorrect, "\nGuess: "
    guess = gets[0]

    if word.include? guess
      if not correct.include? guess
        correct += guess
      end
    else
      if not incorrect.include? guess
        incorrect += guess
      end
    end

    if incorrect.length >= 6
      puts "\n========\n  LOSS\n  The word was '" + word + "'\n========\n"
      break
    end

  end
end
