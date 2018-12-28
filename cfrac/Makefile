all: cfrac

cfrac: cfrac.o ../asm/io.o
	ld cfrac.o ../asm/io.o -o cfrac

cfrac.o: cfrac.S
	as --gstabs+ cfrac.S -o cfrac.o

../io.o: ../asm/io.S
	as --gstabs+ ../asm/io.S -o io.o
