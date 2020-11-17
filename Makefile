CC=gcc
CFLAGS=-g -Wall
LDFLAGS=

.PHONY: all

all: escapify

escapify: escapify.c
	$(CC) -Wall -o $@ $^ $(CFLAGS) $(LDFLAGS)

.PHONY: clean

clean:
	rm -f escapify *.o
