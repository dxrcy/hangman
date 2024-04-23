use std::{ collections::HashSet, env, fs, io::{self, Write},
    time::{SystemTime, UNIX_EPOCH},
};

fn main() -> Result<(), &'static str> {
    println!("=== HANGMAN ===");

    let mut args = env::args().skip(1);
    let Some(filename) = args.next() else {
        return Err("Please provide a file path.");
    };

    let Ok(file) = fs::read_to_string(filename) else {
        return Err("Failed to read file.");
    };
    let words: Vec<_> = file.lines().collect();

    println!("\n\n\n\n\n");

    loop {
        let index = random_int(words.len());
        let word = words[index];

        let mut correct = HashSet::<char>::new();
        let mut incorrect = HashSet::<char>::new();

        loop {
            for _ in 0..5 {
                print!("\x1b[A\x1b[K");
            }

            let mut visible = String::with_capacity(word.len());
            let mut is_win = true;
            for ch in word.chars() {
                if correct.contains(&ch) {
                    visible.push(ch);
                } else {
                    visible.push('_');
                    is_win = false;
                }
            }

            if is_win {
                println!("---------");
                println!("You win! :)");
                println!("The word was: '{}'", word);
                println!("---------");
                read_char();
                break;
            }
            if incorrect.len() >= 6 {
                println!("---------");
                println!("You lose! :(");
                println!("The word was: '{}'", word);
                println!("---------");
                read_char();
                break;
            }

            println!("{}", visible);
            println!("Chances: {}", 6 - incorrect.len());
            print!("Correct: ");
            print_set(&correct);
            print!("Incorrect: ");
            print_set(&incorrect);
            print!("Guess: ");

            let Some(guess) = read_char() else {
                continue;
            };

            if word.contains(guess) {
                correct.insert(guess);
            } else {
                incorrect.insert(guess);
            }
        }
    }
}

fn random_int(max: usize) -> usize {
    let now = SystemTime::now();
    let duration = now.duration_since(UNIX_EPOCH).unwrap();
    let nanos = duration.subsec_nanos() as usize;
    nanos % max
}

fn print_set(set: &HashSet<char>) {
    for (i, ch) in set.iter().enumerate() {
        if i > 0 {
            print!(", ");
        }
        print!("{}", ch);
    }
    println!();
}

fn read_char() -> Option<char> {
    let mut string = String::new();
    let _ = io::stdout().flush();
    io::stdin().read_line(&mut string).unwrap();
    string
        .chars()
        .next()
        .filter(|ch| *ch != '\r' && *ch != '\n')
}

