# *FFI* and `.so` library

Everything starts from the will of running a super awesome *C* library from within *Torch*.
So, let's start step by step, with the writing of the *C* source code.

## *C* source code

So, for this super mega project we would like to fill an `int` *array* of length `size` with the index of each of its elements starting from `1`.

```c
void dummy(int* ptrFromLua, int size) {

  for (int i = 0; i < size; i++)
    ptrFromLua[i] = i + 1;

  return;

}
```

What this code does is simply *defining* a *routine* (or `void` *function*) called `dummy`, which expects a *pointer* to a `int` *array* of `size` elements. Once it is called, it iterates over all the *array* by filling its elements with their *C* index `+ 1`. Then it `return` a `void`.
The source code is available at [`src/asdf.c`](src/asdf.c).

## *make* and `.so` compilation

Now we need to build our *shared library* from the *C* source file. As for convention, the library name will be `lib` + *name* + `.so`, so in this case we'll end up with a file called `libasdf.so`.

For compiling the source code shown above into a *shared library* we need to use *gcc* with several arguments.
In order to simplify this procedure, a [`src/Makefile`](src/Makefile) can be created instead, where all this information can be directly executed by typing the command `make` from within the [`src`](src) directory.

### Compilation details

For the more curious of the readers, I'm going to briefly explain how the [`src/Makefile`](src/Makefile) has been written.

```makefile
LIBOPTS = -shared
CFLAGS = -fPIC -std=gnu99
CC = gcc

libasdf.so : asdf.c
	$(CC) $< $(LIBOPTS) $(CFLAGS) -o $@

clean :
	rm *.so
```

`CC` specifies the *compiler* that is going to be used; `-shared` means we are going to create a *shared library* from a `-fPIC` *Position Independent Code* (there is no `main()` function) which has a variable definition within a `for` definition, and therefore, requires `-std=gnu99`.  
Hence, typing `make` will build an `-o` output `libasdf.so` from the source code `asdf.c`.  
If we would like to remove every file generated by *make*, we can simply issue `make clean` and it will do the trick.

## Scripting in *Lua*

## Motivation