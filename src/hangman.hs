import Control.Exception (try, SomeException)
import qualified Data.Set as Set
import System.Environment
import System.Exit
import System.IO
import System.Random

main :: IO ()
main = do
    putStrLn "=== HANGMAN ==="
    
    args <- getArgs
    if length args < 1 then do
        hPutStrLn stderr "Please provide a file path."
        exitWith $ ExitFailure 1
    else do
        let filename = head args

        result <- try $ readFile filename :: IO (Either SomeException String)
        case result of
            Left _ -> do
                hPutStrLn stderr "Failed to read file."
                exitWith $ ExitFailure 2
            Right contents -> do
                let allWords = lines contents

                putStrLn "\n\n\n\n\n"
                _ <- infiniteLoop allWords
                return ()

infiniteLoop :: [String] -> IO ()
infiniteLoop allWords = do
    index <- randomRIO (0, length allWords - 1)
    let word = allWords !! index
    let correct = Set.empty
    let incorrect = Set.empty

    _ <- gameLoop word correct incorrect
    infiniteLoop allWords

gameLoop :: String -> CharSet -> CharSet -> IO ()
gameLoop word correct incorrect = do
    putStr $ concat $ replicate 5 "\x1b[A\x1b[K"

    let visible = mapVisible correct word
    let isWin = not $ any (== '_') visible

    if isWin then do
        putStrLn "---------"
        putStrLn "You win! :)"
        putStrLn $ "The word was: '" ++ word ++ "'"
        putStrLn "---------"
        _ <- getLine
        return ()
    else if length incorrect >= 6 then do
        putStrLn "---------"
        putStrLn "You lose! :("
        putStrLn $ "The word was: '" ++ word ++ "'"
        putStrLn "---------"
        _ <- getLine
        return ()
    else do
        putStrLn visible
        putStrLn $ "Chances: " ++ (show $ 6 - length incorrect)
        putStrLn $ "Correct: " ++ (joinArray $ Set.toList correct)
        putStrLn $ "Incorrect: " ++ (joinArray $ Set.toList incorrect)
        putStr "Guess: "
        hFlush stdout

        line <- getLine
        let guess = head line

        if length line < 1 then do
            gameLoop word correct incorrect
        else if guess == '\n' then do
            return ()
        else if elem guess word then
            gameLoop word (Set.insert guess correct) incorrect
        else
            gameLoop word correct (Set.insert guess incorrect)

type CharSet = Set.Set Char

mapVisible :: CharSet -> String -> String
mapVisible correct = map (\ch -> if Set.member ch correct then ch else '_')

joinArray :: String -> String
joinArray []     = []
joinArray [x]    = [x]
joinArray (x:xs) = (x : ", " ++ joinArray xs)

