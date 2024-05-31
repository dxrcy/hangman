const fs = require("fs");
const readline = require("readline");

main();
async function main() {
    console.log("=== HANGMAN ===");

    if (process.argv.length < 3) {
        console.error("Please provide a file path.");
        process.exit(1);
    }
    const filename = process.argv[2];

    let file;
    try {
        file = fs.readFileSync(filename, "utf8");
    } catch {
        console.error("Failed to read file.");
        process.exit(2);
    }
    const words = file.split(/\r?\n/);

    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });

    console.log("\n\n\n\n\n");

    while (true) {
        const index = randomInt(words.length);
        const word = words[index];
        let correct = new Set();
        let incorrect = new Set();

        while (true) {
            for (let i = 0; i < 5; i++) {
                process.stdout.write("\x1b[A\x1b[K");
            }

            let visible = "";
            let is_win = true;
            for (let ch of word) {
                if (correct.has(ch)) {
                    visible += ch;
                } else {
                    visible += "_";
                    is_win = false;
                }
            }

            if (is_win) {
                console.log("---------");
                console.log("You win! :)");
                console.log(`The word was: '${word}'`);
                console.log("---------");
                await readInput(rl, "");
                break;
            }
            if (incorrect.size >= 6) {
                console.log("---------");
                console.log("You lose! :(");
                console.log(`The word was: '${word}'`);
                console.log("---------");
                await readInput(rl, "");
                break;
            }

            console.log(visible);
            console.log("Chances: " + (6 - incorrect.size));
            console.log("Correct: " + Array.from(correct).join(", "));
            console.log("Incorrect: " + Array.from(incorrect).join(", "));

            let line = await readInput(rl, "Guess: ");
            if (line.length < 1) {
                continue;
            }
            let guess = line[0];

            if (word.includes(guess)) {
                correct.add(guess);
            } else {
                incorrect.add(guess);
            }
        }
    }
}

function randomInt(max) {
    return Math.round(Math.random() * max);
}

function readInput(rl, prompt) {
    return new Promise((resolve, _reject) => {
        rl.question(prompt, (input) => {
            resolve(input);
        });
    });
}

