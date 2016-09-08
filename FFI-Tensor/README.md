# `Tensor`s through *FFI*

In the first tutorial we saw how to edit the values of the array associated with the underlying `Storage` of a `Tensor`.
Here we'll see how to send the whole `Tensor` to *C* and access its internals.

## *C* source code

The main difference is that we need to `#include <TH/TH.h>` in our [`src/size.c`](src/size.c)

```c
#include <TH/TH.h>

void printSize(THFloatTensor* src) {
  ...
}
```

in order to be able to use `THFloatTensor` and other *Torch* releated stuff.

## Compilation details

Moreover, we need to tell `gcc` where to find libraries and shared objects.
We can do this by adding some options to our [`src/Makefile`](src/Makefile)

```makefile
LIBOPTS = -I$(HOME)/torch/install/include -L$(HOME)/torch/install/lib -lTH
```

where `$(HOME)` points to your home `~`, `-I` provide the location of the *header* file, `-L` specify where to find the shared object which is located with the `-l` (lowercase *L*) argument, and which name here is `libTH.so` or `libTH.dylib`.

## Scripting in *Lua*

Finally, from *Lua* [`src/main.lua`](src/main.lua) will send the whole `Tensor`'s `struct`

```lua
-- Main program ----------------------------------------------------------------
-- Define a random sized Tensor
math.randomseed(os.time())
x = torch.FloatTensor(unpack(torch.Tensor(math.random(10)):random(10):totable()))
-- Send it to C
C.printSize2D(x:cdata())
```

