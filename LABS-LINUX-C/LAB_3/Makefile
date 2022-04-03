CC = gcc
CFLAGS = -W -Wall -Wextra -std=c11
.PHONY: clean

all: parent child
parent: parent.c Makefile
	$(CC) $(CFLAGS) parent.c -o parent
child: child.c Makefile
	$(CC) $(CFLAGS) child.c -o child
clean:
	rm parent child
