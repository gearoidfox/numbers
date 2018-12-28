all: sundaram erato

sundaram: sundaram.c
	gcc -o sundaram sundaram.c -Wall -Wextra -std=c99 -g -O3

erato: erato.o ../asm/io.o
	ld erato.o ../asm/io.o -o erato

erato.o: erato.S
	as --gstabs+ erato.S -o erato.o

../asm/io.o: ../asm/io.S
	as --gstabs+ ../asm/io.S -o ../asm/io.o
