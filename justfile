@default:
	@just --list

# Go
go:
	go run src/go/hangman.go

# Java
java:
	java src/java/hangman.java

# Javascript
js:
	node src/javascript/hangman.js

# Lua
lua:
	lua src/lua/hangman.lua

# Python
py:
	python src/python/hangman.py

# Rust
rs:
	echo coming soon

# Ruby
rb:
	ruby src/ruby/hangman.rb

# Shell (bash)
sh:
	sh src/shell/hangman.sh

# Typescript
ts:
	ts-node src/typescript/hangman.rs

# Zig
zig:
	zig run src/zig/hangman.zig

