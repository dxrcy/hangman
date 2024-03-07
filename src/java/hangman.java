import java.util.Scanner;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import java.util.Random;
import java.util.List;

public class Hangman {
    public static void main(String[] args) {
        System.out.println("=== Hangman ===");

        List<String> words;
        try {
            Path file = new File("words.txt").toPath();
            words = Files.readAllLines(file);
        } catch (IOException err) {
            System.err.println("Failed to read file");
            return;
        }

        Random randGen = new Random();
        Scanner scanner = new Scanner(System.in);

        while (true) {
            int index = randGen.nextInt(words.size());
            String word = words.get(index);
            String correct = "";
            String incorrect = "";

            while (true) {
                String show = "";
                for (int i = 0; i < word.length(); i++) {
                    char ch = word.charAt(i);
                    if (correct.indexOf(ch) >= 0) {
                        show += ch;
                    } else {
                        show += "_";
                    }
                }

                if (show.equals(word)) {
                    System.out.println("\n========\n   WIN\n========");
                    break;
                }

                System.out.printf(
                        "\n%s\nChances: %d\nCorrect: %s\nIncorrect: %s\n",
                        show,
                        6 - incorrect.length(),
                        correct,
                        incorrect);

                System.out.print("Guess: ");
                char guess = scanner.next().charAt(0);

                if (word.indexOf(guess) >= 0) {
                    if (correct.indexOf(guess) < 0) {
                        correct += guess;
                    }
                } else {
                    if (incorrect.indexOf(guess) < 0) {
                        incorrect += guess;
                    }
                }

                if (incorrect.length() >= 6) {
                    System.out.printf("\n========\n  LOSS\n  The word was '%s'\n========\n", word);
                    break;
                }
            }
        }
    }
}
