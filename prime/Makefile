all: sundaram erato

sundaram: sundaram.c
	gcc -o sundaram sundaram.c -Wall -Wextra -std=c99 -g -O3

erato: erato.o io.o
	ld erato.o io.o -o erato

erato.o: erato.S
	as --gstabs+ erato.S -o erato.o

io.o: io.S
	as --gstabs+ io.S -o io.o
