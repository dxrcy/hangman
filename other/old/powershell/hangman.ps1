Write "`n=== Hangman ==="
$words = (Get-Content .\words.txt ).split("`n")

for () {
  $word = $words[(Get-Random -Minimum 0 -Maximum $words.length)]
  $correct = ""
  $incorrect = ""

  for () {

    $show = ""
    for ($i = 0; $i -le $word.length - 1; $i++) {
      if ($correct.contains($word[$i])) {
        $show += $word[$i]
      } else {
        $show += "_"
      }
    }
    
    if ($show -eq $word) {
      Write "`n========`n   WIN`n========"
      break
    }

    Write "`n$show`nChances: $(6 - $incorrect.length)`nCorrect: $correct`nIncorrect: $incorrect"
    $guess = Read-Host "Guess"

    if ($word.contains($guess)) {
      if (-not $correct.contains($guess)) {
        $correct += $guess
      }
    } else {
      if (-not $incorrect.contains($guess)) {
        $incorrect += $guess
      }
    }

    if ($incorrect.length -gt 5) {
      Write "`n========`n  LOSS`n  The word was '${word}'`n========"
      break 
    }
  }
}