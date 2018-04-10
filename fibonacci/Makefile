all: xfib

xfib: xfib.o
	ld xfib.o -o xfib

xfib.o: xfib.S
	as --gstabs+ xfib.S -o xfib.o
