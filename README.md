# Under the Hood of Torch

This repository tries to provide some advanced tricks with [Torch7](http://torch.ch/) explained easily

## *FFI* series

[*LuaJIT*](http://luajit.org/) [*FFI library*](http://luajit.org/ext_ffi.html) provides an incredible easy way to call external C functions and use C data structures from pure Lua code.
The *FFI series* will provide several working examples of playing with C from within Torch, taking for granted no prior knowledge of building `.so` libraries, using `.make` files or tackling *Tensors* pointers.

 - *FFI* and `.so` library
