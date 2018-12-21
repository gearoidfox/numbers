all: coprime coprime.png

coprime: coprime.c
	gcc -Wall -std=c89 -O3 coprime.c -o coprime

coprime.png: coprime plot.py
	./coprime | python3 plot.py 4
