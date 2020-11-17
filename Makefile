CC=cc
CFLAGS= #-g -Wall
LDFLAGS=

.PHONY: all

all: escapify

escapify: escapify.c
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

.PHONY: clean

clean:
	rm -f escapify *.o
