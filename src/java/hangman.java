import java.util.Scanner;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import java.util.Random;
import java.util.List;
import java.util.ArrayList;
import java.util.HashSet;

import java.lang.Character;

public class Hangman {
    public static void main(String[] args) {
        System.out.println("=== HANGMAN ===");

        if (args.length < 2) {
            System.err.println("Please provide a file path.");
            System.exit(1);
            return;
        }
        String filename = args[1];

        List<String> words;
        try {
            Path file = new File(filename).toPath();
            words = Files.readAllLines(file);
        } catch (IOException err) {
            System.err.println("Failed to read file");
            System.exit(2);
            return;
        }

        Random randGen = new Random();
        Scanner scanner = new Scanner(System.in);

        System.out.println("\n\n\n\n");

        while (true) {
            int index = randGen.nextInt(words.size());
            String word = words.get(index);
            HashSet<Character> correct = new HashSet<>();
            HashSet<Character> incorrect = new HashSet<>();

            System.out.println("Secret: " + word);
            correct.add('a');
            correct.add('e');

            while (true) {
                for (int i = 0; i < 5; i++) {
                    System.out.print("\033[A\033[K");
                }

                String visible = "";
                boolean is_win = true;
                for (int i = 0; i < word.length(); i++) {
                    char ch = word.charAt(i);
                    if (correct.contains(ch)) {
                        visible += ch;
                    } else {
                        visible += '_';
                        is_win = false;
                    }
                }

                if (is_win) {
                    System.out.println("---------");
                    System.out.println("You win! :)");
                    System.out.printf("The word was: '%s'\n", word);
                    System.out.print("---------");
                    scanner.nextLine();
                    break;
                }
                if (incorrect.size() >= 6) {
                    System.out.println("---------");
                    System.out.println("You lose! :(");
                    System.out.printf("The word was: '%s'\n", word);
                    System.out.print("---------");
                    scanner.nextLine();
                    break;
                }

                System.out.println(visible);
                System.out.printf("Chances: %d\n", 6 - incorrect.size());
                System.out.print("Correct: ");
                printSet(correct);
                System.out.print("Inorrect: ");
                printSet(incorrect);
                System.out.print("Guess: ");

                String line = scanner.nextLine();

                if (line.length() < 1) {
                    continue;
                }
                char guess = line.charAt(0);

                if (word.indexOf(guess) >= 0) {
                    correct.add(guess);
                } else {
                    incorrect.add(guess);
                }
            }
        }
    }

    static void printSet(HashSet<Character> set) {
        int i = 0;
        for (Character ch : set) {
            if (i > 0) {
                System.out.print(", ");
            }
            System.out.print(ch);
            i++;
        }
        System.out.println();
    }
}

