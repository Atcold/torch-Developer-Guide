LIBOPTS = -shared
CFLAGS = -fPIC -std=gnu99
CC = gcc

libasdf.so : asdf.c
	$(CC) $< $(LIBOPTS) $(CFLAGS) -o $@

clean :
	rm *.so
