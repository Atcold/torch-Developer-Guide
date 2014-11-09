################################################################################
# Make file for building the shared library
################################################################################
# Alfredo Canziani, Nov 14
################################################################################

LIBOPTS = -shared
CFLAGS = -fPIC -std=gnu99
CC = gcc

libasdf.so : asdf.c
	$(CC) $< $(LIBOPTS) $(CFLAGS) -o $@

clean :
	rm *.so
