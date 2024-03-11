@default:
	@just --list

words := "words/lf.txt"

# Go
go:
	go run src/hangman.go {{words}}

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
# pwsh:
# 	pwsh src/hangman.ps1

# Python
py:
	python src/hangman.py {{words}}

# Ruby
# rb:
# 	ruby src/hangman.rb

# Rust
rs:
	rustc src/hangman.rs -o dist/hangman && dist/hangman {{words}}

# Shell (bash)
sh:
	sh src/hangman.sh {{words}}

# Typescript
ts:
	ts-node src/hangman.ts {{words}}

# Zig
zig:
	zig run src/hangman.zig -- {{words}} 

