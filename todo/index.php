 <?php

$file = fopen("words.txt", "r") or die("Unable to open");
$words = explode("\r\n", fread($file, filesize("words.txt")));
fclose($file);

for ($a = 0; $a < 10; $a++) {
  $word = $words[random_int(0, count($words) - 1)];
  $correct = "";
  $incorrect = "";

  for ($b = 0; $b < 10; $b++) {
    $show = "";
    for ($i = 0; $i < strlen($word); $i++) {
      if (strpos($correct, $word[$i])) {
        $show .= $word[$i];
      } else {
        $show .= "_";
      }
    }

    if ($show == $word) {
      echo "win";
    }
  }
}
