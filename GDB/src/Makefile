################################################################################
# Make file for building the shared library
################################################################################
# Alfredo Canziani, Nov 14
################################################################################

LIBOPTS = -shared
CFLAGS = -fPIC -std=gnu99 -g
CC = gcc

libsegfault.so : segfault.c
	$(CC) $< $(LIBOPTS) $(CFLAGS) -o $@

clean :
	rm -rf *.so*
