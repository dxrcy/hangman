#include <fstream>
#include <iostream>
#include <set>
#include <string>
#include <vector>

using std::cerr;
using std::cout;
using std::endl;
using std::set;
using std::string;
using std::vector;

void print_set(const set<char>& set) {
    int i = 0;
    for (char ch : set) {
        if (i > 0) {
            cout << ", ";
        }
        cout << ch;
        ++i;
    }
    cout << endl;
}

int main(int argc, char** argv) {
    cout << "=== HANGMAN ===" << endl;

    if (argc < 2) {
        cerr << "Please provide a file path." << endl;
        return 1;
    }

    std::ifstream file;
    file.open(argv[1]);
    if (!file.is_open()) {
        cerr << "Failed to read file." << endl;
        return 2;
    }

    vector<string> words;
    while (!file.eof()) {
        string word;
        file >> word;
        if (!word.empty()) {
            words.push_back(word);
        }
    }

    srand(time(NULL));

    cout << "\n\n\n\n\n\n";

    while (true) {
        const int index = rand() % words.size();
        const string& word = words[index];
        set<char> correct;
        set<char> incorrect;

        while (true) {
            for (int i = 0; i < 5; i++) {
                cout << "\x1b[A\x1b[K";
            }

            string visible = "";
            bool is_win = true;
            for (char ch : word) {
                if (correct.count(ch) > 0) {
                    visible += ch;
                } else {
                    visible += '_';
                    is_win = false;
                }
            }

            if (is_win) {
                cout << "---------" << endl;
                cout << "You win! :)" << endl;
                cout << "The word was: '" << word << "'" << endl;
                cout << "---------" << endl;
                getchar();
                break;
            }
            if (incorrect.size() >= 6) {
                cout << "---------" << endl;
                cout << "You lose! :(" << endl;
                cout << "The word was: '" << word << "'" << endl;
                cout << "---------" << endl;
                getchar();
                break;
            }

            cout << visible << endl;
            cout << "Chances: " << (6 - incorrect.size()) << endl;
            cout << "Correct: ";
            print_set(correct);
            cout << "Incorrect: ";
            print_set(incorrect);
            cout << "Guess: ";

            const char guess = getchar();
            if (guess == '\n') {
                continue;
            }
            while (getchar() != '\n');

            if (word.find(guess) != string::npos) {
                correct.insert(guess);
            } else {
                incorrect.insert(guess);
            }
        }
    }
}
