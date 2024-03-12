param(
    [string]$filename
)

Write-Host "=== HANGMAN ==="

if (-not $filename) {
    Write-Error "Please provide a file path."
    Exit 1
}

try {
    $file = Get-Content $filename -ErrorAction Stop
} catch {
    Write-Error "Failed to read file."
    Exit 2
}

$words = $file.split("`n")

Write-Host "`n`n`n`n`n"

for () {
    $index = Get-Random -Minimum 0 -Maximum $words.length
    $word = $words[$index]
    $correct = New-Object System.Collections.Generic.HashSet[char]
    $incorrect = New-Object System.Collections.Generic.HashSet[char]

    for () {
        for ($i = 0; $i -lt 5; $i++) {
            Write-Host -NoNewline "`e[A`e[K"
        }

        $visible = ""
        $is_win = $true
        foreach ($ch in $word.ToCharArray()) {
            if ($correct.Contains($ch)) {
                $visible += $ch
            } else {
                $visible += "_"
                $is_win = $false
            }
        }

        if ($is_win) {
            Write-Host "---------"
            Write-Host "You win! :)"
            Write-Host "The word was: '$word'"
            Write-Host -NoNewline "---------"
            Read-Host
            break
        }
        if ($incorrect.Count -ge 6) {
            Write-Host "---------"
            Write-Host "You lose! :("
            Write-Host "The word was: '$word'"
            Write-Host -NoNewline "---------"
            Read-Host
            break
        }

        Write-Host $visible
        Write-Host "Chances: $(6 - $incorrect.Count)"
        Write-Host "Correct: $([string]::Join(', ', $correct))"
        Write-Host "Incorrect: $([string]::Join(', ', $incorrect))"

        $line = Read-Host "Guess"
        if ($line.length -ne 1) {
            continue
        }
        $guess = $line[0]

        if ($word.Contains($guess)) {
            $correct.Add($guess) > $null
        } else {
            $incorrect.Add($guess) > $null
        }
    }
}

