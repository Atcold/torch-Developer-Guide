################################################################################
# Make file for building the shared library + GDB debugging option
################################################################################
# Alfredo Canziani, Sep 16
################################################################################

LIBOPTS = -shared
CFLAGS = -fPIC -std=gnu99 -ggdb
CC = gcc

libsegfault.so : segfault.c
	$(CC) $< $(LIBOPTS) $(CFLAGS) -o $@

clean :
	rm -rf *.so*
