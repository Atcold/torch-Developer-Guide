# *FFI* / `.so` debugging with *ADB*

Let's say you've made your pretty nice *Lua* script that interfaces to a shared object which, after executing some instructions, miserably dies with a `Segmentation fault`.

To let you feel the thrill youself, `cd` into [`src`](src), `make` the project and then run `th run.lua`.
If you're on *Mac*, you'll get something like

```
$ th run.lua
Running a function from a shared object
Segmentation fault: 11
```

and if you're on *Ubuntu*, you'll see

```
$ th run.lua
Running a function from a shared object
Segmentation fault (core dumped)
```

In both cases, you'll see **only one** line of red text and the very little informative message regarding something that went wrong.

Our poor little *Lua* script actually wanted to print one more red line...

```lua
-- Main program ----------------------------------------------------------------
local red = require('trepl.colorize').red
print(red 'Running a function from a shared object')
myLib.A()
print(red 'Never here')
```

but the bad and evil `.so` library ruined it all.
How to move forward?

## GDB

[GDB](https://www.gnu.org/software/gdb/), *the GNU Project debugger, allows you to see [...] what another program was doing at the moment it crashed.*
Pretty sweet, uh?
Since we're using `gdb`, I've included the flag `-ggdb` in the [`Makefile`](src/Makefile), which provides us with even more sweet treats, but it is not strictly required (so, this works even with `.so` compiled by someone else).

> If you're on *Ubuntu*, `gdb` should be already there, ready to use.
> Simply check whether `man gdb` returns anything.
> On *Mac* things are a little more tedious, but not that bad, overall.
> To install it we'll use brew, of course.
>
> ```
> brew update
> brew insatll gdb
> ```
>
> Then we will need to *codesign* the `gdb` executable in order to allow the debugger to control other processes (on the *Darwin Kernel*) on your *Mac*.
> To do so, follow the instructions [here](https://gcc.gnu.org/onlinedocs/gnat_ugn/Codesigning-the-Debugger.html) untill rebooting.
> Then, type this in your terminal
>
> ```bash
> sudo codesign -f -s "gdb-cert" $(which gdb)
> ```

Let's run *Torch* with `gdb` monitoring what's happening.

```bash
gdb --args bash $(which th) run.lua
```

You'll see something like this

```gdb
$ gdb --args bash $(which th) run.lua
GNU gdb (Ubuntu 7.11.1-0ubuntu1~16.04) 7.11.1
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from bash...(no debugging symbols found)...done.
```

Type `run`, and you'll get `th` execute the script

```gdb
(gdb) run
Starting program: /bin/bash /home/atcold/torch/install/bin/th run.lua
process 16671 is executing new program: /home/atcold/torch/install/bin/luajit
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Running a function from a shared object

Program received signal SIGSEGV, Segmentation fault.
0x00007fffdbbe0729 in D () at segfault.c:8
8         *(int*)0 = 0;
```

> On *Mac* it's likely you will also have to type `continue`
>
> ```gdb
> (gdb) run
> Starting program: /bin/bash /Users/atcold/torch/install/bin/th run.lua
>
> Program received signal SIGTRAP, Trace/breakpoint trap.
> 0x00007fff5fc01000 in ?? ()
> (gdb) continue
> Continuing.
> Running a function from a shared object
>
> Program received signal SIGSEGV, Segmentation fault.
> D () at segfault.c:8
> 8         *(int*)0 = 0;
> ```

So, here we have already a great deal of information.
We know that the killing function is `D()`.
Even if we would have not use the `-ggdb` flag we would have known this, given that the output would have looked like this

```gdb
Running a function from a shared object

Program received signal SIGSEGV, Segmentation fault.
0x00007fffdbbe0729 in D () from /home/atcold/Work/GitHub/torch-Developer-Guide/GDB/src/libsegfault.so
```

But here, since we could, we run `-ggdb` as an option of `gcc`, which gives us the name of the incriminated source code (`segfault.c`) and its breaking line (`8`) and instruction (`*(int*)0 = 0;`).
Otherwise, all we would have got would have been the name of the `.so` (`[...]/libsegfault.so`) and the breaking function name (`D()`).

Finally, we can go back to how we eneded up calling `D()` by printing the whole *stack traceback* by typing `backtrace`.

```gdb
(gdb) backtrace
#0  0x00007fffdbbe0729 in D () at segfault.c:8
#1  0x00007fffdbbe0740 in C () at segfault.c:13
#2  0x00007fffdbbe0751 in B () at segfault.c:18
#3  0x00007fffdbbe0762 in A () at segfault.c:23
#4  0x000000000047fb79 in lj_vm_ffi_call ()
#5  0x00000000004508e1 in lj_ccall_func ()
#6  0x0000000000452d86 in lj_cf_ffi_meta___call ()
#7  0x000000000047dbba in lj_BC_FUNCC ()
#8  0x000000000046e842 in lj_cf_dofile ()
#9  0x000000000047dbba in lj_BC_FUNCC ()
#10 0x000000000046d15d in lua_pcall ()
#11 0x0000000000406eaf in pmain ()
#12 0x000000000047dbba in lj_BC_FUNCC ()
#13 0x000000000046d1d7 in lua_cpcall ()
#14 0x0000000000404e54 in main ()
```

And the `in D () at segfault.c:8` and the following 3 lines would have become something like `in D () from /home/atcold/Work/GitHub/torch-Developer-Guide/GDB/src/libsegfault.so` if the `-ggdb` would have been missing.

And this is the end.I wrote this because I was getting a `Segentation fault` and I had no clue what was going on.
Now I feel I'm armed with a very powerful tool, that allows me to dig deeper and deeper into my compiled objects which I'm calling from *Torch* via the *FFI*.
