app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br",
    rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.3.0/hPlOciYUhWMU7BefqNzL89g84-30fTE6l2_6Y3cxIcE.tar.br",
}

import pf.Arg
import pf.Stdin
import pf.Stdout
import pf.File
import rand.Random

IOError : [StdoutErr Stdout.Err, StdinErr Stdin.Err]

main : Task {} [Exit I32 Str]IOError
main =
    Stdout.line! "=== HANGMAN ==="
    filename : Str
    filename = tryGetFilenameArg!
    lines = tryReadFileLines! filename
    state = Random.seed 42
    Stdout.line! "Ok."
    infiniteLoop { state, lines }

tryGetFilenameArg : Task Str [Exit I32 Str]IOError
tryGetFilenameArg =
    args = Arg.list {} |> Task.mapErr! (\_ -> crash "Failed to get arguments.")
    List.get args 1
    |> Task.fromResult
    |> Task.mapErr (\_ -> Exit 1 "Please provide a file path.")

tryReadFileLines : Str -> Task (List Str) [Exit I32 Str]_
tryReadFileLines = \path ->
    File.readUtf8 path
        |> Task.mapErr! (\_ -> Exit 2 "Failed to read file.")
        |> Str.split "\n"
        |> Task.ok

infiniteLoop : { state : Random.State, lines : List Str }
    -> Task {} [Exit I32 Str]IOError
infiniteLoop = \{ state, lines } ->
    Stdout.line! "infiniteLoop"
    generator = Random.boundedU32 0 (List.len lines |> Num.toU32)
    { state: nextState, value: index } = generator state
    Stdout.line! "Index: $(index |> Inspect.toStr)"
    word =
        when List.get lines 0 is
            Ok a -> a
            Err _ -> crash "what?"
    Stdout.line! "Answer: $(word)"
    correct = []
    incorrect = []

    gameLoop! { word, correct, incorrect }

    _ = Stdin.line!
    infiniteLoop! { state: nextState, lines } # compiler bug bruh
    Task.ok {}

Char : U8

gameLoop : { word : Str, correct : List Char, incorrect : List Char }
    -> Task {} [Exit I32 Str]IOError
gameLoop = \{ word, correct, incorrect } ->
    Stdout.line! "gameLoop"
    if List.len incorrect >= 6 then
        Stdout.line! "you lose."
        Task.ok {}
    else
        gameLoop! {
            word,
            correct,
            incorrect: incorrect |> List.append 0x41u8,
        }
        Task.ok {}

