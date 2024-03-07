use std::fs;
use std::io::{stdin, stdout, Write};

fn main() {
    println!("=== Hangman ===");

    let file =
        fs::read_to_string("words.txt").expect("Should have been able to read the file");
    let words: Vec<&str> = file.split("\r\n").collect();

    loop {
        let index = random_int(words.len());
        let word: &str = words[index];
        let mut correct = String::from("");
        let mut incorrect = String::from("");

        loop {
            let mut show = String::with_capacity(word.len());
            for x in word.chars() {
                if correct.contains(x) {
                    show.push(x);
                } else {
                    show.push('_');
                }
            }

            if show == word {
                println!("\n========\n   WIN\n========");
                break;
            }

            println!(
                "\n{}\nChances: {}\nCorrect: {}\nIncorrect: {}",
                show,
                6 - incorrect.len(),
                correct,
                incorrect
            );

            let guess = input(&"Guess: ").chars().next().unwrap();

            if word.contains(guess) {
                if !correct.contains(guess) {
                    correct.push(guess);
                }
            } else {
                if !incorrect.contains(guess) {
                    incorrect.push(guess);
                }
            }

            if incorrect.len() >= 6 {
                println!("\n========\n  LOSS\n  The word was '{}'\n========", word);
                break;
            }
        }
    }
}

fn random_int(max: usize) -> usize {
    use std::time::{SystemTime, UNIX_EPOCH};
    let now = SystemTime::now();
    let duration = now.duration_since(UNIX_EPOCH).unwrap();
    let nanos = duration.subsec_nanos() as usize;
    nanos % max
}

fn input(prompt: &str) -> String {
    let mut s = String::new();
    print!("{}", prompt);

    let _ = stdout().flush();
    stdin()
        .read_line(&mut s)
        .expect("Did not enter a correct string");

    if let Some('\n') = s.chars().next_back() {
        s.pop();
    }
    if let Some('\r') = s.chars().next_back() {
        s.pop();
    }

    s
}
