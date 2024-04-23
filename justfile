@default:
	@just --list

words := "words/lf.txt"

outfile := "./hangman"

# C
c:
	echo '(unfinished)' &&\
	gcc -Wall todo/hangman.c -o {{outfile}} && {{outfile}} {{words}}

# Go
go:
	go run src/hangman.go {{words}}

# Haskell
hs:
	ghc -Wall -dynamic src/hangman.hs -o {{outfile}} && {{outfile}} {{words}}

# Java
java:
	java src/hangman.java {{words}} 

# Javascript
js:
	node src/hangman.js {{words}}

# Lua
lua:
	lua src/hangman.lua {{words}}

# Powershell
pwsh:
	pwsh src/hangman.ps1 {{words}}

# Python
py:
	python src/hangman.py {{words}}

# Ruby
rb:
	ruby src/hangman.rb {{words}}

# Rust
rs:
	rustc src/hangman.rs -o {{outfile}} && {{outfile}} {{words}}

# Shell (bash)
sh:
	sh src/hangman.sh {{words}}

# Typescript
ts:
	ts-node src/hangman.ts {{words}}

# Zig
zig:
	zig run src/hangman.zig -- {{words}} 

