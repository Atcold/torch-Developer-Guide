################################################################################
# Make file for building the shared library
################################################################################
# Alfredo Canziani, Sep 16
################################################################################

LIBOPTS = -I$(HOME)/torch/install/include -L$(HOME)/torch/install/lib -lTH
CFLAGS = -fPIC -shared
CC = gcc

libsize.so : size.c
	$(CC) $< $(LIBOPTS) $(CFLAGS) -o $@

clean :
	rm *.so
