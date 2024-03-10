@default:
	@just --list

words := "words/lf.txt"

# Go
go:
	go run src/go/hangman.go

# Java
java:
	java src/java/hangman.java -- {{words}} 

# Javascript
js:
	node src/javascript/hangman.js

# Lua
lua:
	lua src/lua/hangman.lua

# Powershell
pwsh:
	pwsh src/powershell/hangman.ps1

# Python
py:
	python src/python/hangman.py

# Ruby
rb:
	ruby src/ruby/hangman.rb

# Rust
rs:
	rustc src/rust/hangman.rs -o dist/hangman && dist/hangman {{words}}

# Shell (bash)
sh:
	sh src/shell/hangman.sh

# Typescript
ts:
	ts-node src/typescript/hangman.ts

# Zig
zig:
	zig run src/zig/hangman.zig -- {{words}} 

