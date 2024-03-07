const fs = require("fs");
const readline = require("readline");

console.log("=== Hangman ===");
var words: string[] = fs.readFileSync("words.txt").toString().split("\r\n");

(async function (): Promise<void> {
    while (true) {
        var word: string = words[Math.floor(Math.random() * words.length)];
        var correct = "";
        var incorrect = "";

        while (true) {
            var show = "";
            for (var i = 0; i < word.length; i++) {
                if (correct.includes(word[i])) {
                    show += word[i];
                } else {
                    show += "_";
                }
            }

            if (show === word) {
                console.log("\n========\nWIN\n========");
                break;
            }

            console.log(
                "\n" +
                    show +
                    "\nChances: " +
                    (6 - incorrect.length) +
                    "\nCorrect: " +
                    correct +
                    "\nIncorrect: " +
                    incorrect,
            );

            var guess: string = await new Promise((resolve) => {
                var rl = readline.createInterface(process.stdin, process.stdout);
                rl.question("Guess: ", (res: string) => {
                    resolve(res);
                    rl.close();
                });
            });

            if (word.includes(guess)) {
                if (!correct.includes(guess)) {
                    correct += guess;
                }
            } else {
                if (!incorrect.includes(guess)) {
                    incorrect += guess;
                }
            }

            if (incorrect.length >= 6) {
                console.log(`\n========\n  LOSS\n  The word was '${word}'\n========`);
                break;
            }
        }
    }
})();
