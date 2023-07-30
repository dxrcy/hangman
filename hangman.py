import random

print ("\n=== Hangman ===")
words = open("words.txt", "r").read().split("\n")

while True:
  word = words[random.randint(0, (len(words) - 1))]
  correct = ""
  incorrect = ""

  while True:
    show = ""
    for i in word:
      if i in correct:
        show += i
      else:
        show += "_"
    
    if show == word:
      print ("\n========\n   WIN\n========")
      break
    
    print (f"\n{show}\nChances: {str(6 - len(incorrect))}\nCorrect: {correct}\nIncorrect: {incorrect}")
    guess = input("Guess: ")

    if guess in word:
      if guess not in correct:
        correct += guess
    else:
      if guess not in incorrect:
        incorrect += guess

    if len(incorrect) >= 6:
      print(f"\n========\n  LOSS\n  The word was '{word}'\n========")
      break
